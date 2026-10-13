#!/bin/sh
# 用法：cd /Users/aduan/dawn && sh _tools/make-sitemap.sh > sitemap.xml
# lastmod 來源順序：頁內 JSON-LD 的 dateModified（唯一正本）→ 該檔最後一次 git commit 日期（只適用沒有 JSON-LD 的頁，如 private.html）→ 今天（尚未 commit 的新頁）
# 不使用檔案 mtime（git checkout/clone 會重置 mtime，造成全站假跳日期）。
BASE="https://norway.com.tw"
echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
for f in index.html $(ls *.html | grep -v '^index.html$' | grep -v '^_' | grep -v '^thanks.html$' | grep -v '^404.html$' | sort); do
  d=$(grep -o '"dateModified": *"[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' "$f" | head -1 | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}')
  [ -z "$d" ] && d=$(git log -1 --format=%cs -- "$f")
  [ -z "$d" ] && d=$(date +%F)
  loc="$BASE/$f"; [ "$f" = "index.html" ] && loc="$BASE/"
  printf '  <url><loc>%s</loc><lastmod>%s</lastmod></url>\n' "$loc" "$d"
done
echo '</urlset>'
