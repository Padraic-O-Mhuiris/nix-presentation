---
theme: default
background: https://raw.githubusercontent.com/NixOS/nixos-artwork/c1dc75611042b57a385c80495d3728724c35cfee/wallpapers/nix-wallpaper-nineish.src.svg
class: "text-center"
highlighter: shiki
lineNumbers: true
drawings:
  persist: false
colorscheme: light
css: windicss
fonts:
  sans: "Roboto"
  serif: "Roboto Slab"
  mono: "Ubuntu Mono"
---

# Nix

How to build software from the future

<!-- --- -->
<!-- src: ./pages/what_is_nix.md -->
<!-- --- -->

---
layout: center
---

# Core Idea of Nix

<br/>
<br/>

> Everything on your computer implicitly depends on a bunch of other things on your computer

<br/>
<br/>

<v-clicks>

- All software is a graph of dependencies
- This graph is mostly implicit
- Nix forces this graph to be explicit

</v-clicks>

---
layout: center
---

<img src="/images/git_dependency_graph_1.svg" class="max-w-250 max-h-100" alt="...">

---
layout: center
---

<img src="/images/git_dependency_graph_2.svg" class="max-w-250 max-h-100" alt="...">

---
layout: center
---

# Four key ideas:

<v-clicks>

- Store
- Language
- Derivation
- Sandboxing

</v-clicks>

---
layout: two-cols
---

# The Nix Store

<br/>

<v-clicks>

When nix is installed, a special directory, `/nix/store` is created

This directory is just a graph database

Every sub-directory is a node

<div>

Example:

```bash
/nix/store/q1i8hccfgx0al5jhx5n610jwwqa3jijx-git-2.38.1
```

</div>

Everything under a `node` directory is considered immutable

In a node, there may be references to paths in other nodes, creating an edge

</v-clicks>

::right::

```bash
/nix/store/9xfad3b5z4y00mzmk2wnn4900q0qmxns-glibc-2.35-224
/nix/store/f1n473kbcxxr38f7amwf4sxyi56mfczh-expat-2.5.0
/nix/store/fblaj5ywkgphzpp5kx41av32kls9256y-zlib-1.2.13
/nix/store/wim4mqpn8lxhhr10p2kd070hyj152lil-bash-5.1-p16
/nix/store/65cp4izx3bllnwqn7c7dhrq9h9gmjkal-python3-3.10.9
/nix/store/88k0f4k4hb13mjqm1xc0sysjysrrw813-gzip-1.12
/nix/store/8n4g9jl8s2v8sla6gffa03gy1gkk1pqm-perl5.36.0-URI-5.05
/nix/store/a19azdhwnvmksbpfz0crb4d1l9l19b2d-git-2.38.1-doc
/nix/store/ncwm1bgg4x4k7ixjni5bxj3v7b2x5lyb-perl5.36.0-FCGI-0.79
/nix/store/k32xzhjqyvgmjnkckvk2h3gbjpdb3hfl-perl5.36.0-HTML-Parser-3.75
/nix/store/w2gxv2p9831ypflpk61l7sjzi8j05agj-perl5.36.0-CGI-4.51
/nix/store/a509h53d4vki546clzig63kh6h4qyps4-perl5.36.0-CGI-Fast-2.15
...
...
/nix/store/xryxkg022p5vnlyyyx58csbmfc7ydsdp-curl-7.86.0
/nix/store/z6976dw306w5fn1d4sg7xwc1x3cszy1s-perl5.36.0-FCGI-ProcManager-0.28
/nix/store/z97bsdbkh6b60xpi12sqi6a0d28ql8cy-pcre2-10.40
/nix/store/q1i8hccfgx0al5jhx5n610jwwqa3jijx-git-2.38.1
```

<sub>Some of the direct dependencies for git</sub>


---
layout: center
---

<code>
/nix/store/<b>q1i8hccfgx0al5jhx5n610jwwqa3jijx</b>-git-2.38.1
</code>

<br/>
<br/>

<v-clicks>

Every node has a unique hash

For a given hash, the contents of that node will always be identical, across machines, platforms, etc

If the hash differs, then the contents differs

> Note: A node can also be referred to as an `outputPath`, which will be important later

</v-clicks>

---
layout: center
---

The Nix Store is a graph database

<v-clicks>

More specifically a **directed acyclic graph** database

And we get to query it like a database

<div>

```bash
# List's all the direct dependencies of git
nix-store --query --references /nix/store/q1i8hccfgx0al5jhx5n610jwwqa3jijx-git-2.38.1

# Models the "transitive closure" of the git dependency graph
nix-store --query --graph /nix/store/q1i8hccfgx0al5jhx5n610jwwqa3jijx-git-2.38.1 | dot -Tsvg
```

</div>

</v-clicks>

---
layout: two-cols
---

# Nix Derivations

Simply put, derivations are the building blocks of a Nix system

<table v-if="$slidev.nav.clicks >= 1">
  <tr></tr>
  <tr v-if="$slidev.nav.clicks >= 1">
    <td>outputs</td>
    <td>What nodes can this build?</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 2">
    <td>inputDrvs</td>
    <td>Other derivations which must be built before this one</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 3">
    <td>inputSrcs</td>
    <td>Nodes already in the Nix Store which this build depends</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 4">
    <td>platform</td>
    <td>x86_64-linux, aarch64-darwin, ...</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 5">
    <td>builder</td>
    <td>Program to run to do the build</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 6">
    <td>args</td>
    <td>Argument to pass to the builder program</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 7">
    <td>env</td>
    <td>Environment to set before calling the builder</td>
  </tr>
</table>

::right::

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

```bash {all|4|5|6|7|8|9|10,11,12,13,14,15}
$ cat /nix/store/856p...gdl5-demo.drv

Derive(
  [("out","/nix/store/vy11....nc34-demo","","")],
  [("/nix/store/0lj5...30xs-bash-5.1-p16.drv",["out"])],
  [],
  "x86_64-linux",
  "/nix/store/iffl...1kmi-bash-5.1-p16/bin/bash",
  ["-c","echo \"Hello World!\" > $out\n"],
  [
    ("builder","/nix/store/iffl...1kmi-bash-5.1-p16/bin/bash"),
    ("name","demo"),
    ("out","/nix/store/vy114...9nc34-demo"),
    ("system","x86_64-linux")
  ]
)
```


<!-- --- -->
<!-- src: ./pages/nix_philosophy.md -->
<!-- --- -->
