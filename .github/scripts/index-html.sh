#!/usr/bin/env bash
# Renders the charts.felukka.org homepage from a Helm index.yaml (Pages from
# Actions serves files as-is, so without this "/" is a 404).
# Usage: index-html.sh <index.yaml> > index.html
set -euo pipefail
index="$1"
repo="https://github.com/felukka/charts"

esc() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

cards=""
for name in $(yq '.entries | keys | .[]' "$index"); do
  version=$(yq ".entries.\"$name\"[0].version" "$index" | esc)
  app=$(yq ".entries.\"$name\"[0].appVersion // \"\"" "$index" | esc)
  desc=$(yq ".entries.\"$name\"[0].description // \"\"" "$index" | esc)
  cards+="<a class=\"card\" href=\"$repo/tree/main/charts/$name\">
  <h3>$name <span>$version</span></h3>
  <p>$desc</p>
  <code>helm install $name felukka/$name</code>${app:+
  <small>app $app</small>}
</a>
"
done

cat <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Felukka Helm Charts</title>
<meta name="description" content="Helm charts for Koptan and other Felukka products.">
<link rel="icon" href="https://felukka.org/favicon.svg" type="image/svg+xml">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600&family=Space+Grotesk:wght@600;700&display=swap">
<style>
  :root {
    --primary: #eac07d; --on-primary: #432c00; --bg: #0e1419; --surface: #161c22;
    --surface-high: #242b30; --text: #dde3ea; --muted: #c3c7ce; --outline: #43474d;
  }
  @media (prefers-color-scheme: light) {
    :root {
      --primary: #7a5a1f; --on-primary: #ffffff; --bg: #ffffff; --surface: #f7f8fa;
      --surface-high: #eef1f4; --text: #0e1419; --muted: #43474d; --outline: #c3c7ce;
    }
  }
  * { box-sizing: border-box; }
  body { margin: 0; background: var(--bg); color: var(--text); font: 16px/1.6 "Manrope", sans-serif; }
  main { max-width: 960px; margin: 0 auto; padding: 48px 16px; }
  header { display: flex; align-items: center; gap: 12px; margin-bottom: 40px; }
  header img { width: 40px; height: 40px; }
  header a { color: var(--text); text-decoration: none; font: 700 20px "Space Grotesk", sans-serif; }
  h1, h2, h3 { font-family: "Space Grotesk", sans-serif; line-height: 1.2; }
  h1 { font-size: clamp(2rem, 6vw, 3rem); margin: 0 0 8px; }
  .lead { color: var(--muted); margin: 0 0 24px; }
  pre { background: var(--surface); border: 1px solid var(--outline); border-radius: 8px;
        padding: 16px; overflow-x: auto; font-size: 14px; }
  pre, code { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 16px; }
  .card { display: block; background: var(--surface); border: 1px solid var(--outline); border-radius: 8px;
          padding: 16px; color: var(--text); text-decoration: none; }
  .card:hover, .card:focus-visible { border-color: var(--primary); background: var(--surface-high); }
  .card h3 { margin: 0 0 6px; font-size: 18px; }
  .card h3 span { font: 600 12px "Manrope", sans-serif; color: var(--on-primary); background: var(--primary);
                  border-radius: 999px; padding: 2px 8px; vertical-align: middle; }
  .card p { margin: 0 0 10px; color: var(--muted); font-size: 14px; }
  .card code { font-size: 13px; color: var(--primary); overflow-wrap: anywhere; }
  .card small { display: block; color: var(--muted); margin-top: 6px; }
  footer { margin-top: 48px; color: var(--muted); font-size: 14px; }
  footer a { color: var(--primary); }
</style>
</head>
<body>
<main>
  <header>
    <img src="https://felukka.org/favicon.svg" alt="">
    <a href="https://felukka.org">Felukka</a>
  </header>
  <h1>Helm Charts</h1>
  <p class="lead">Install Koptan and other Felukka products on Kubernetes.</p>
  <pre><code>helm repo add felukka https://charts.felukka.org
helm repo update</code></pre>
  <h2>Charts</h2>
  <div class="grid">
$cards  </div>
  <footer>
    Also on OCI: <code>oci://ghcr.io/felukka/charts/&lt;name&gt;</code> ·
    <a href="index.yaml">index.yaml</a> · <a href="$repo">Source</a>
  </footer>
</main>
</body>
</html>
HTML
