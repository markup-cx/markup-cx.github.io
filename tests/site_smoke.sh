#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

for page in index docs markdown roadmap; do
    test -s "public/$page.html"
    grep -F '<meta name="viewport"' "public/$page.html" >/dev/null
    grep -F 'assets/style.css' "public/$page.html" >/dev/null
    grep -F 'assets/site.js' "public/$page.html" >/dev/null
    grep -F 'href="./docs.html"' "public/$page.html" >/dev/null
    grep -F 'href="./markdown.html"' "public/$page.html" >/dev/null
    grep -F 'href="./roadmap.html"' "public/$page.html" >/dev/null
done

grep -F 'markup README.md -o README.html' public/index.html >/dev/null
grep -F 'Full CommonMark conformance' public/markdown.html >/dev/null
grep -F 'AsciiDoc' public/roadmap.html >/dev/null
grep -F 'reStructuredText' public/roadmap.html >/dev/null
grep -F 'Nift embedding' public/roadmap.html >/dev/null

if find content -type f \( -name '*.css' -o -name '*.js' \) | grep -q .; then
    echo 'static CSS/JS must not be duplicated under content/' >&2
    exit 1
fi
if grep -Eq 'assets/.*\.(css|js)' .nift/tracked.json; then
    echo 'static CSS/JS must not be tracked by Nift' >&2
    exit 1
fi
if grep -R -E '#[0-9a-fA-F]{3,8}.*#[0-9a-fA-F]{3,8}' public/assets/style.css | grep -qiE '#[0-9a-fA-F]*(00f|09f|0af|19f|29f|39f|49f|59f|69f|79f|89f|9af|aaf|baf|caf|daf|eaf|faf)'; then
    echo 'review palette: possible blue introduced' >&2
    exit 1
fi

echo 'website smoke checks passed'
