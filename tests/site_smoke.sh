#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

for page in index docs markdown asciidoc restructuredtext docs/battle-tested docs/ai-opinion; do
    test -s "public/$page.html"
    grep -F '<meta name="viewport"' "public/$page.html" >/dev/null
    grep -F 'assets/style.css' "public/$page.html" >/dev/null
    grep -F 'assets/site.js' "public/$page.html" >/dev/null
    grep -F '>Docs</a>' "public/$page.html" >/dev/null
    grep -F '>Markdown</a>' "public/$page.html" >/dev/null
    grep -F '>AsciiDoc</a>' "public/$page.html" >/dev/null
    grep -F '>reStructuredText</a>' "public/$page.html" >/dev/null
    grep -F '>Battle tested</a>' "public/$page.html" >/dev/null
    grep -F '>AI opinion</a>' "public/$page.html" >/dev/null
    grep -F '<title>Markup++</title>' "public/$page.html" >/dev/null
    grep -F 'rel="icon" type="image/svg+xml"' "public/$page.html" >/dev/null
done

for script in install.sh download.sh update.sh uninstall.sh; do
    test -s "$script"
    test -s "public/$script"
    cmp "$script" "public/$script"
    sh -n "$script"
done

grep -F 'curl -fsSL https://markup.cx/install.sh | sh' public/docs.html >/dev/null
grep -F 'curl -fsSL https://markup.cx/install.sh | sh' public/index.html >/dev/null
grep -F 'https://github.com/markup-cx/markup' public/index.html >/dev/null
grep -F 'https://github.com/markup-cx/markup.git' public/docs.html >/dev/null
grep -F 'rel="canonical" href="https://markup.cx/' public/index.html >/dev/null
grep -F 'rel="canonical" href="https://markup.cx/markdown.html"' public/markdown.html >/dev/null
grep -F 'og:site_name' public/index.html >/dev/null

test "$(grep -oF 'curl -fsSL https://markup.cx/install.sh | sh' public/index.html | wc -l)" -eq 1
if grep -F '$ markup README.md' public/index.html >/dev/null; then
    echo 'homepage install block must contain only the install command' >&2
    exit 1
fi
grep -F '652/652' public/markdown.html >/dev/null
grep -F 'markup --extensions' public/markdown.html >/dev/null
grep -F 'Docutils 0.23 core profile passed' public/index.html >/dev/null
grep -F 'AD0-AD11' public/asciidoc.html >/dev/null
grep -F '13 current alpha TCK inputs' public/asciidoc.html >/dev/null
grep -F 'explicit host resolver' public/docs.html >/dev/null
grep -F 'markup guide.adoc -o guide.html' public/asciidoc.html >/dev/null
grep -F 'Docutils 0.23' public/restructuredtext.html >/dev/null
grep -F 'markup manual.rst -o manual.html' public/restructuredtext.html >/dev/null
grep -F '652/652' public/docs/battle-tested.html >/dev/null
grep -F 'A strong first release.' public/docs/ai-opinion.html >/dev/null
test ! -e public/roadmap.html
test -s public/favicon.svg

grep -F 'language-bash' public/docs.html >/dev/null
grep -F 'language-cpp' public/docs.html >/dev/null
grep -F 'language-markdown' public/markdown.html >/dev/null
grep -F 'language-html' public/markdown.html >/dev/null
grep -F 'language-asciidoc' public/asciidoc.html >/dev/null
grep -F 'language-bash' public/restructuredtext.html >/dev/null
grep -F '.kw{' public/assets/style.css >/dev/null
grep -F '.str{' public/assets/style.css >/dev/null
grep -F 'language-' public/assets/site.js >/dev/null

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
if grep -rF --include='*.html' 'nift-dev' public >/dev/null; then
    echo 'obsolete nift-dev operational URL found in generated site' >&2
    exit 1
fi

grep -F '<link rel="sitemap"' public/index.html >/dev/null
if grep -F 'Release candidate 0.1.0' public/index.html >/dev/null; then
    echo 'stale release candidate phrase on homepage' >&2
    exit 1
fi
grep -F 'Latest release 0.1.0' public/index.html >/dev/null
test -s public/sitemap.xml

echo 'website smoke checks passed'
