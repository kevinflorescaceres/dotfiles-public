#!/usr/bin/env -S python3 -I
"""Local, PR-like review page for a git range. Stdlib only.

Usage: review_html.py REPO BASE HEAD OUT.html "Title"
"""
import json, subprocess, sys

repo, base, head, out, title = sys.argv[1:6]
EXCLUDE = [":(exclude).claude/agent-memory", ":(exclude)db/schema.rb"]


def git(*args):
    return subprocess.run(["git", "-C", repo, *args], capture_output=True, text=True, check=True).stdout


def parse(diff_text):
    files, f, hunk, minus, plus = [], None, None, [], []

    def flush():
        nonlocal minus, plus
        for i in range(max(len(minus), len(plus))):
            o = minus[i] if i < len(minus) else None
            n = plus[i] if i < len(plus) else None
            hunk["rows"].append([o and o[0], o and o[1], "del" if o else "", n and n[0], n and n[1], "add" if n else ""])
        minus, plus = [], []

    for line in diff_text.splitlines():
        if line.startswith("diff --git "):
            if hunk: flush()
            hunk = None
            f = {"path": line.split(" b/", 1)[1], "status": "M", "add": 0, "del": 0, "blob": "", "hunks": [], "old": None}
            files.append(f)
        elif f is None:
            continue
        elif hunk is None and line.startswith("index "):
            f["blob"] = line.split()[1].split("..")[1]
        elif hunk is None and line.startswith("new file"):
            f["status"] = "A"
        elif hunk is None and line.startswith("deleted file"):
            f["status"] = "D"
        elif hunk is None and line.startswith("rename from "):
            f["status"], f["old"] = "R", line[12:]
        elif hunk is None and line.startswith("Binary files"):
            f["binary"] = True
        elif line.startswith("@@"):
            if hunk: flush()
            spec = line.split("@@")[1].split()
            o_no = int(spec[0][1:].split(",")[0])
            n_no = int(spec[1][1:].split(",")[0])
            hunk = {"header": line, "rows": []}
            f["hunks"].append(hunk)
        elif hunk is not None:
            tag, text = line[:1], line[1:]
            if tag == "-":
                minus.append((o_no, text)); o_no += 1; f["del"] += 1
            elif tag == "+":
                plus.append((n_no, text)); n_no += 1; f["add"] += 1
            elif tag == " ":
                flush()
                hunk["rows"].append([o_no, text, "", n_no, text, ""]); o_no += 1; n_no += 1
    if hunk: flush()
    return files


def view(label, key, a, b):
    return {"label": label, "key": key, "files": parse(git("diff", "--no-color", "-U3", "-M", a, b, "--", ".", *EXCLUDE))}


commits = [l.split(" ", 1) for l in git("log", "--reverse", "--format=%h %s", f"{base}..{head}").splitlines()]
views = [view(f"Todo: {base}..{head}", "all", base, head)]
views += [view(f"{sha} {subject}", sha, f"{sha}^", sha) for sha, subject in commits]
data = json.dumps({"title": title, "views": views}).replace("</", "<\\/")

page = open(__file__.replace(".py", ".template.html")).read()
open(out, "w").write(page.replace("__TITLE__", title).replace("__DATA__", data))
print(out, len(views[0]["files"]), "archivos,", len(commits), "commits")
