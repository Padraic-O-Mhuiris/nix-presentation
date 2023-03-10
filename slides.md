---
theme: seriph
background: https://raw.githubusercontent.com/NixOS/nixos-artwork/c1dc75611042b57a385c80495d3728724c35cfee/wallpapers/nix-wallpaper-nineish.src.svg
class: "text-center"
highlighter: shiki
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


---
layout: center
---

# What is Nix?

---
layout: center
---

Nix is a _universal_ build system and purely functional package manager

---
layout: center
---

It's also a language

```nix
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "hello";
  src = ./src;
  buildInputs = [ coreutils gcc ];
  configurePhase = ''
    declare -xp
  '';
  buildPhase = ''
    gcc "$src/hello.c" -o ./hello
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp ./hello "$out/bin/"
  '';
}
```

---
layout: center
---

Can be used on any "Unix-Like" systems like Mac and Linux

<v-click>

Install it like so:

```bash
$ sh <(curl -L https://nixos.org/nix/install)
```

</v-click>

---
layout: center
---

Also comes in it's own Linux flavour - NixOS

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/NixOS_logo.svg/1280px-NixOS_logo.svg.png)

---
layout: center
---

Largest package collection for any package manager, >95K - [_nixpkgs_](https://github.com/NixOS/nixpkgs)

<img src="https://repology.org/graph/map_repo_size_fresh.svg" class="max-w-full max-h-100" alt="..." />

---
layout: center
---

Steep learning curve

<img src="https://discourse.nixos.org/uploads/default/original/2X/f/fef4e7f73fbca41179060500174f1448d16fb8c9.jpeg" class="max-w-full max-h-100" alt="...">

---
layout: center
---

But I think it's worth it

---

# What problems does Nix solve | What does Nix do?

<br/>
<br/>
<br/>

<v-clicks>

- Multiple versions of the same package can be installed on your system
- Dependency Hell is solved, where a package is installed which has dependencies which conflict because they rely on shared packages or libraries of different versions
- 0 ambiguity on where packages/libraries live on your system
- Reproducibile environments without virtualisation
- Binary caching for all software
- API driven package building
- Atomic system rollbacks and upgrades (NixOS)
- System configuration is declarative and shareable (NixOS)

</v-clicks>

---
layout: center
---

It's core ideas will be how software is developed, built and distributed in the future


---
layout: center
---

Let's look at those core ideas

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
- This graph should be explicit

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

# Nix in 4 parts:

<v-clicks>

- Store
- Language
- Derivation
- Hermeticity

</v-clicks>

---
layout: center
---

# The Nix Store

---
layout: two-cols
---

# The Nix Store

<br/>

<v-clicks>

When Nix is installed, `/nix/store` is created

This directory is a graph database

Where every sub-directory is a node

<div>

Example package:

```bash
/nix/store/q1i8hccfgx0al5jhx5n610jwwqa3jijx-git-2.38.1
```

</div>

Build artifacts like the `git` binary are contained in a node

`/nix/store/q1i8hccfgx0al5jhx5n610jwwqa3jijx-git-2.38.1/bin/git`

Nix uses symlinks to reference paths to other packages which may be required at runtime, creating edges

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

<sub>Some of the direct dependencies for git in `/nix/store`</sub>


---
layout: center
---

<code>
/nix/store/<b>q1i8hccfgx0al5jhx5n610jwwqa3jijx</b>-git-2.38.1
</code>

<br/>
<br/>

<v-clicks>

Every node is identified by a unique hash

For a given hash, the contents of that node will always be identical

Across different machines, platforms and architectures

If a hash is different, then the contents are different

<div>

<br/>

> Note: A node can also sometimes be referred to as an `outputPath` or `outPath`

</div>

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
layout: center
---

# The Nix Derivation

---
layout: two-cols
clicks: 2
---

# The Nix Derivation

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

A derivation is a recipe to build some package

It's just a file of build instructions

<table v-if="$slidev.nav.clicks >= 1">
  <tr></tr>
  <tr v-if="$slidev.nav.clicks >= 1">
    <td>drvPath</td>
    <td>Recipe <code>.drv</code> file containing build instructions</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 2">
    <td>outPath</td>
    <td>Location of build artifacts</td>
  </tr>
</table>

::right::

<br/>
<br/>
<br/>
<br/>

```mermaid {theme: 'dark', scale: 2.5}
flowchart TD
drv[drvPath] --> x[outPath]
```

---
layout: two-cols
---

# The Nix Derivation

<br/>

Derivations are the product of evaluating Nix expressions

<v-clicks>

Specifically Nix expressions which call the `derivation` function

We will talk about this later

The demo example on the right is a simplified Nix expression

There are multiple ways to evaluate a Nix expression using the tooling

<div>
The easiest is:

```bash
$ nix-instantiate demo.nix
```
</div>

</v-clicks>

::right::

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

```nix
with import <nixpkgs> { };

builtins.derivation {
  name = "demo";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  args = [
    "-c"
    ''
      echo "Hello World!" > $out
    ''
  ];
}
```


---
layout: two-cols
---

# The Nix Derivation

### Derivation structure

<br/>
<br/>

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

```bash {all|2|3|4|5|6|7|8-13}
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


---

Essentially .drv files are just a fancy json

```bash
nix show-derivation /nix/store/856pm4kv8ddsr0qnbjzprpfm7sbfgdl5-demo.drv
```

```json{all|5}
{
  "/nix/store/856pm4kv8ddsr0qnbjzprpfm7sbfgdl5-demo.drv": {
    "outputs": {
      "out": {
        "path": "/nix/store/vy114fkxdsw4fb7ysfp86p8l32z9nc34-demo"
      }
    },
    "inputSrcs": [],
    "inputDrvs": {
      "/nix/store/0lj5m63bn3ins5qiq6chs1vz3nk030xs-bash-5.1-p16.drv": [
        "out"
      ]
    },
    "system": "x86_64-linux",
    "builder": "/nix/store/iffl6dlplhv22i2xy7n1w51a5r631kmi-bash-5.1-p16/bin/bash",
    "args": [
      "-c",
      "echo \"Hello World!\" > $out\n"
    ],
    "env": {
      "builder": "/nix/store/iffl6dlplhv22i2xy7n1w51a5r631kmi-bash-5.1-p16/bin/bash",
      "name": "demo",
      "out": "/nix/store/vy114fkxdsw4fb7ysfp86p8l32z9nc34-demo",
      "system": "x86_64-linux"
    }
  }
}
```

---
layout: center
---

Everything* in the Nix Store, except derivations are created using derivations

---
layout: center
---

Derivations are built using some variant of the `nix-build`/`nix build` command

<v-clicks>

```bash
$ nix-build /nix/store/856pm4kv8ddsr0qnbjzprpfm7sbfgdl5-demo.drv # legacy
```

or

```bash
$ nix build /nix/store/856pm4kv8ddsr0qnbjzprpfm7sbfgdl5-demo.drv --print-output-paths # newer > nix-2.4
```

producing the `outPath`

```bash
/nix/store/vy114fkxdsw4fb7ysfp86p8l32z9nc34-demo # The node outpath
```

verifying the build went correctly

```bash
$ cat /nix/store/vy114fkxdsw4fb7ysfp86p8l32z9nc34-demo

Hello World!
```

</v-clicks>

---
layout: center
---

![](/images/nix_eval_build.svg)

---
layout: two-cols
---

## How are the hashes generated?

<br/>

<v-clicks>

This is low-level so just a simple overview

For a **derivation** hash, it typically is just the sha256 or md5 of the derivation contents

For an **output** hash, it typically is the sha256 or md5 of the derivation hash + the output name ("out")

So if we change the version of the bash dependency stated in the derivation, the derivation hash will change

Which will propagate a change to the output hash

This turns each unique package node in the Nix Store and it's children dependencies into something similar to merkle-tree structures

</v-clicks>

::right::

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<img src="/images/derivation_hashing.svg" class="max-w-250 max-h-70" alt="...">

---
layout: center
---

By this method, we create a unique fingerprint on <ins>how</ins> a piece of software is built

<v-clicks>

Not *always* a unique fingerprint on <ins>what</ins> software is built

Exact byte-for-byte equality is not always the case across two separate builds

It depends if the `builder` program is deterministic

In other words, store paths are hashes of the **build instructions** not the contents

Nix store paths are **input addressed**

**Content-addressed** solutions are the "holy grail" for Nix

Where a hash of an output path is also available

Currently are being slowly released and should reach wider adoption as time progresses

</v-clicks>

---
layout: center
---

# Hermeticity

---

# Pure vs Hermetic

<br/>
<br/>
<br/>

Nix is described as a <ins>pure</ins> functional package manager

<v-clicks>

Instead of pure it's more precise to say it's <ins>**hermetic**</ins>

**Pure** means where a program or function for some input will emit the same output - deterministic

No _side-effects_ are created

This is the desired goal of Nix

<ins>Hermetic</ins> is more accurate

</v-clicks>

---
layout: two-cols
---

# Hermeticity

<br/>
<br/>
<br/>
<br/>
<br/>

Rooted from the Greek god, Hermes, who amongst other things was the god of boundaries

<v-clicks>

In more scientific contexts it means the concept of being **airtight** or **gastight**

In software, it means a program which is <ins>fully independent</ins> or <ins>isolated</ins>

</v-clicks>

::right::

![](https://media.istockphoto.com/id/507882363/vector/hermes-greek-god-of-transitions-wood-engraving-published-1878.jpg?s=1024x1024&w=is&k=20&c=pa2gzLTbcYO9Z19p4fId_yhFXkcLKbJ5jJgQ9C_3VWA=
)

---
layout: center
---

# Nix builds are Hermetic

<br/>

<v-clicks>

Builds are executed in an isolated _"sandbox"_

All builds are done by a special user called `nixbld`

Which only has access to content in the Nix Store

The build runtime is executed in a "chrooted" environment

Access to the network and the external host filesystem is restricted (some caveats)

"Fixed-output" derivations enable network access to fetch binaries directly

</v-clicks>

---
layout: two-cols
---

# Fixed-output derivations

<br/>

Sometimes a binary or package may be released as a compressed tarball on github or elsewhere

It is possible to package such a binary in a derivation

The derivation will specify a URL the binary can be fetched from and a hash

The tarball will be hashed and validated against the specified hash

This makes it easier to integrate with the non-nix world

And avoids having to package all software from scratch

But building software from scratch the _**"Nix Way"**_ is better

::right::

<br/>
<br/>
<br/>

```nix
{ pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  name = "prysmbeacon";
  version = "3.1.0";
  src = fetchurl {
    url =
      "https://github.com/prysmaticlabs/prysm/releases/download/v${version}/beacon-chain-v${version}-linux-amd64";
    sha256 = "f76aed03c207c2e4ade1c1cde47cbc0828bb7fb9b44d5518e6f13a9b39dacc42";
  };
  installPhase = ''
    mkdir $out/bin
    mv $src $out/bin/prysmbeacon
  '';
}
```


---
layout: center
---

# Dependency closure of `git`

<br/>

<img src="/images/git_dependency_graph_1.svg" class="max-w-220 max-h-100" alt="...">

<v-clicks>

Everything is explicit

Extremely strong guarantees of reproducibility

Entire dependency closure can be copied to another machine

Provided the same system architecture

</v-clicks>

---
layout: center
---

### Things either work everywhere and always or nowhere and never

---
layout: center
---

![](https://ih1.redbubble.net/image.1939881742.9679/flat,750x,075,f-pad,750x1000,f8f8f8.u2.jpg)

---
layout: center
---

### With Nix any software build/install can be a binary download

<br/>

<v-clicks>

- Once a package derivation has been built somewhere on some machine
- That graph can be compressed, copied and dumped directly into your nix store
- Everything is "built" in parallel which makes it extremely fast
- Turns every Nix Store into an automatic binary-caching layer
- [Cachix/nix-community cache](https://www.cachix.org/) is a binary cache which enable this
- Can be potentially decentralized using bittorrent
- Have been some attempts to use IPFS

</v-clicks>

---
layout: center
---

## The Nix Language

---
layout: center
---

- Probably the most challenging part for people new to Nix

<v-clicks>

- Weird syntax, similarities to Haskell, dynamically typed
- It's a <ins>D</ins>omain <ins>S</ins>pecific <ins>L</ins>anguage
- Functional, pure and lazy - we'll talk about this

</v-clicks>

---
layout: two-cols
---

### Nix is <ins>functional</ins>, pure and lazy

Everything is either a function or data

<v-clicks>

```nix
addOne = x: x + 1;
```

<div>
<br/>

```nix
{
  string = "hello";
  integer = 1;
  float = 3.141;
  bool = true;
  null = null;
  list = [ 1 "two" false ];
  attribute-set = {
    a = "hello";
    b = 2;
    c = 2.718;
    d = false;
  }; # comments are supported
}
```
</div>

</v-clicks>

::right::

<br/>

<v-clicks>

Core language is very small

```nix
nix-repl> builtins.

builtins.abort                          builtins.isAttrs
builtins.add                            builtins.isBool
builtins.addErrorContext                builtins.isFloat
builtins.all                            builtins.isFunction
builtins.any                            builtins.isInt
builtins.appendContext                  builtins.isList
builtins.attrNames                      builtins.isNull
builtins.attrValues                     builtins.isPath
builtins.baseNameOf                     builtins.isString
builtins.bitAnd                         builtins.langVersion
builtins.bitOr                          builtins.length
builtins.bitXor                         builtins.lessThan
builtins.break                          builtins.listToAttrs
builtins.builtins                       builtins.map
builtins.catAttrs                       builtins.mapAttrs
builtins.ceil                           builtins.match
builtins.compareVersions                builtins.mul
builtins.concatLists                    builtins.nixPath
builtins.concatMap                      builtins.nixVersion
builtins.concatStringsSep               builtins.null
builtins.currentSystem                  builtins.parseDrvName
builtins.currentTime                    builtins.partition
builtins.deepSeq                        builtins.path
builtins.derivation                     builtins.pathExists
builtins.derivationStrict               builtins.placeholder
builtins.dirOf                          builtins.readDir
builtins.div                            builtins.readFile
builtins.elem                           builtins.removeAttrs
builtins.elemAt                         builtins.replaceStrings
builtins.false                          builtins.scopedImport
builtins.fetchGit                       builtins.seq
builtins.fetchMercurial                 builtins.sort
builtins.fetchTarball                   builtins.split
builtins.fetchTree                      builtins.splitVersion
builtins.fetchurl                       builtins.storeDir
builtins.filter                         builtins.storePath
builtins.filterSource                   builtins.stringLength
builtins.findFile                       builtins.sub
builtins.floor                          builtins.substring
builtins.foldl'                         builtins.tail
builtins.fromJSON                       builtins.throw
builtins.fromTOML                       builtins.toFile
builtins.functionArgs                   builtins.toJSON
builtins.genList                        builtins.toPath
builtins.genericClosure                 builtins.toString
builtins.getAttr                        builtins.toXML
builtins.getContext                     builtins.trace
builtins.getEnv                         builtins.traceVerbose
builtins.getFlake                       builtins.true
builtins.groupBy                        builtins.tryEval
builtins.hasAttr                        builtins.typeOf
builtins.hasContext                     builtins.unsafeDiscardOutputDependency
builtins.hashFile                       builtins.unsafeDiscardStringContext
builtins.hashString                     builtins.unsafeGetAttrPos
builtins.head                           builtins.zipAttrsWith
builtins.import
builtins.intersectAttrs
```

</v-clicks>

---
layout: center
---

### Nix is functional, pure and <ins>lazy</ins>

<v-clicks>

Lazy/Laziness/Lazy-evaluation just means where <br/>
an expression is evaluated only when it's values are needed

<div>

Suppose:

```nix
let
  data = {
    a = 1;
    b = functionWhichTakesALongTimeToRun 1;
  }
in data.a
```

</div>

`data.b` is never evaluated in Nix

`data.a => 1` is evaluated immediately

</v-clicks>

---
layout: center
---

### Nix is functional, <ins>pure</ins> and lazy

<v-clicks>

We talked a little about this already

Pure as in free (almost!) of side effects

</v-clicks>

<v-clicks>

- no networking
- no user IO
- no writing to file
- no output
- doesn't actually do anything, in the traditional sense
- <ins>Only purpose is to call the `derivation` function</ins>
- The only side-effect is that it writes a derivation path in the nix store

</v-clicks>

---
layout: center
---

# `demo.nix`

<br/>

```nix
with import <nixpkgs> { };

builtins.derivation {
  name = "demo";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  args = [
    "-c"
    ''
      echo "Hello World!" > $out
    ''
  ];
}

```

This then can be evaluated using `nix-instantiate`

Resulting in the derivation file we used earlier

---
layout: center
---


> The Nix language does not do anything except write out derivations, <br/> for which other tooling (`nix-build`) can execute a build

Evaluation of the Nix language is a separate process of building a Nix derivation

---
layout: center
---

So if a given `.nix` file to build some package has stated 100 dependencies

<v-clicks>

The evaluation of that file will recursively write 100 derivations

And then the derivation (_root_) of that package will then be written

The _root_ derivation can then be called by `nix-build`

That dependency graph is traversed again, recursively building 100 dependencies to their outPaths

And finally the _root_ derivation is built to it's outPath utilising all those explicitly stated deps

</v-clicks>

---
layout: center
---


Building software is arbitrarily complex

<v-clicks>

Nix reduces that to just individual derivations

Which expresses the build instructions of a massively complex piece

That is reproducible and reliable

</v-clicks>

![](/images/nix_complexity.png)

---
layout: center
---

The Nix language enables complex descriptions of how to build a piece of software

<v-clicks>

Typically a package manager will only provide only one or a few variants of a given package

Crafting a nix package becomes analogous to creating an API to build that package for every variant

If we look at how [`curl`](https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/tools/networking/curl/default.nix#L185) is packaged

There's a lot of interesting possibilities to build systems with nix

</v-clicks>

---
layout: center
clicks: 6
---

## [Nixpkgs](https://github.com/NixOS/nixpkgs/tree/nixos-22.11)

Global package repository for Nix

<v-clicks>

One of the most active repositories on Github

Always community contributions

Huge, ~95,000 pkgs (depends which branch)

</v-clicks>

<br/>

<table v-if="$slidev.nav.clicks >= 4">
  <tr>
    <th>Branch</th>
    <th>Description</th>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 4">
    <td>nixos-21.11</td>
    <td>Current stable, bi-yearly releases, akin to Ubuntu LTS examples</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 5">
    <td>unstable</td>
    <td>Daily rolling release, pretty "bleeding edge", akin to Arch</td>
  </tr>
  <tr v-if="$slidev.nav.clicks >= 6">
    <td>master</td>
    <td>As up to date as possible, can be broken, comes with warning signs</td>
  </tr>
</table>

---
layout: center
---

Nixpkgs is just a big attrset of lazy-evaluated calls to `derivation`

<v-clicks>

 \>95,000 lazy calls to derivation

```
{
  python = derivation { ... }
  rust = derivation { ... }
  nginx = derivation { ... }
  curl = derivation { ... }
  linux_kernel = derivation { ... }
  .
  .
  .
}
```



</v-clicks>

---
layout: two-cols
---

<br/>
<br/>
<br/>
<br/>

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Nix_snowflake.svg/1004px-Nix_snowflake.svg.png?20201208155042" class="max-w-100 max-h-100" alt="...">

::right::

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>


## That's Nix fundamentals

<v-clicks>

There are more things to randomly cover:

</v-clicks>

<v-clicks>

- Ephemeral shells
- Nix flakes
- Hermetic developer environments
- Nix & Docker
- NixOS
- ... and many more

</v-clicks>

---

## Ephemeral shells

<br/>

### nix-shell

<v-clicks>

Often people will read about nix and hear about `nix-shell` - it's really useful

`nix-shell`, is just a wrapper around `nix-build` but will jump you into a new shell environment

You can specify a package to be downloaded and be added to your shell `PATH`, e.g

```bash
nix-shell -p nodejs-16_x
```

This is very ergonomic for one-time-use of a specific package

Use a `shell.nix` file for larger and more complex setups

```nix
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [ nodejs-16_x ];
}
```

</v-clicks>

---

## Nix Flakes

<v-clicks>

Relatively new-addition to the Nix ecosystem

Prior, what version of nixpkgs needed to build a package was not explicit

Analogous to the role `cargo.toml` and `package.json` serve in a rust or javascript based project

In Nix based projects, you would specify a `flake.nix`

Vastly simplifies how nix based projects can be composed

Still _"experimental"_ but becoming the de-facto standard

Enables any github repo publish a set of derivations like nixpkgs

But it allows more cool stuff

It's divided into two parts, an "input" schema and an "output" schema

</v-clicks>

---
layout: two-cols
---

## Nix Flakes

<br/>

### An input schema

<br/>
<br/>

<v-clicks>

- attribute set of all "derivation set dependencies" (nixpkgs)
- Kind of analogous to the "dependencies" field in a package.json
- Except it declares a collection of packages rather than an individual one
- Very useful when a package isn't included in nixpkgs

</v-clicks>

::right::

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    foo.url = "github:FooCompany/foo";
    bar.url = "github:barCompany/bar/62108d953e7c31115d9d18159af9e49eb029fa9";
  };
};

```

---
layout: two-cols
---

## Nix Flakes

<br/>

### An output schema

<br/>
<br/>

<v-clicks>

- A function of one argument which is an attribute set of all inputs from the input schema
- The output of the function is an attribute set of different flake outputs
- These can then be rationalised by nix tooling to do a variety of things
- `packages` - `nix build . | nix build .#<name>`
- `apps` - `nix run . | nix run .#<name>`
- `devShells` - `nix develop . | nix run .#<name>`

</v-clicks>

::right::

<br/>
<br/>
<br/>
<br/>
<br/>


```nix
# "<system>" - what system architecture
# "<name>" - name of that package/app/devShell/etc

{
  outputs = { self, nixpkgs, ... }@inputs: {

    packages."<system>"."<name>" = derivation;
    packages."<system>".default = derivation;

    apps."<system>"."<name>" = { type = "app";  program = "<store-path>";  };
    apps."<system>".default = { type = "app"; program = "..."; };

    devShells."<system>"."<name>" = derivation;
    devShells."<system>".default = derivation;

    ...
  }
}

```

---
layout: two-cols
clicks: 4
---

## Nix Flakes - Real world example

On the right we have the `flake.nix` for this presentation


<div v-if="$slidev.nav.clicks >= 1">

This builds the static site assets

```bash
nix build .#site
```

</div>

<div v-if="$slidev.nav.clicks >= 2">

This creates a bash script which run's a webserver hosting the files

```bash
nix build .#server
```

</div>

<div v-if="$slidev.nav.clicks >= 3">

This will then run the server

```bash
nix run .
```

</div>

<div v-if="$slidev.nav.clicks >= 4">

You can also run it remotely

```bash
nix run github:Padraic-O-Mhuiris/nix-presentation
```

</div>

::right::

<br/>
<br/>
<br/>
<br/>
<br/>

```nix{all|11-21|22-27|30-34|all}
{
  description = "Nix Presentation";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = {

        site = pkgs.mkYarnPackage rec {
          name = "nix-presentation";
          version = (pkgs.lib.importJSON (src + "/package.json")).version;
          src = ./.;
          buildPhase = "yarn build";
          installPhase = ''
            mkdir -p $out/public;
            mv deps/${name}/dist/* $out/public/
          '';
          distPhase = "true";
        };

        server = pkgs.writeScriptBin "nix-presentation-server" ''
          ${pkgs.webfs}/bin/webfsd -p 3000 -F -j -r ${
            self.packages.${system}.site
          }/public -f index.html
        '';
      };

      apps.${system}.default = {
        type = "app";
        program =
          "${self.packages.${system}.server}/bin/nix-presentation-server";
      };
    };
}
```

---
layout: center
---

This last command:

<v-clicks>

```
nix run <REMOTE_URL>
```

turns everything into a 1-click operation

without any pre-requisites or setup

<img src="https://media.makeameme.org/created/its-magic-5c9ab8.jpg" class="max-w-75" alt="...">

</v-clicks>

---
layout: center
---

## Hermetic Developer Environments

<br/>

<v-clicks>

For a project, there typically requires a process setting up your system in order to begin development

e.g Global deps like node and npm/yarn/pnpm in js have to be globally installed

These are "implied" dependencies of your project

Nix allows for a project to internalise them as dependencies

With essentially no obstruction for the developer

</v-clicks>

---

# Hermetic Developement Environments

<br/>

<v-clicks>

### [`direnv`](https://direnv.net/)

`direnv` is an extension for your shell

Useful for auto-loading environment variables/secrets, just `cd` into a dir

Will read a `.envrc` file and bring everything into scope

### [`nix-direnv`](https://github.com/nix-community/nix-direnv)

Extension to `direnv`, integrates with nix tooling

```bash
echo "use nix" >> .envrc # for shell.nix

echo "use flake" >> .envrc # for a flake devShell
```

Then call `direnv allow` in that directory

</v-clicks>
---

# Hermetic Developement Environments

<br/>

### devShells

The same idea as `shell.nix`, just internalised in a flake - newer way of creating ephemeral shells

<v-clicks>

```bash
nix develop .
```

<br/>

```nix
{
  inputs = { ... };
  outputs = { self, nixpkgs, ... }@inputs:
    {
      devShell.${system} =
        pkgs.mkShell { buildInputs = with pkgs; [ nodejs yarn ]; };
    };
}
```

This makes it straightforward and simple to standardise <ins>**all**</ins> tooling across a team

All dependencies are explicitly self-contained for <ins>**any**</ins> project, regardless of language

With 0 setup to begin working on that project

</v-clicks>

---

# Nix vs Docker

<br/>

Many people often compare Nix and Docker

<v-clicks>

Lot of overlap as both create isolated reproducible environments

But are both fundamentally different:

- Docker is a toolkit for building and deploying containers
- Nix is a package and configuration manager

</v-clicks>

---

# Nix vs Docker

<br/>

### Docker

<v-clicks>

Docker solves reproducible environments by snapshotting system state in an `image`

Images are created from a `DockerFile` like below:

```docker
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
```

That image is then uploaded to a registry where it can be distributed

Not 100% reproducibile between separate image builds

Composition of images is difficult

However, massive ecosystem and easier to grok compared Nix

</v-clicks>

---

# Nix vs Docker

<br/>

### Nix

<v-clicks>

Nix solves reproducibility from a first principles approach

By solving package management

No virtualisation so no runtime overhead

More composable and configurable, a DockerFile can only utilise a single base image to extend from

So, start with a `node` image and then install `rustc` manually

Admittedly it is less user-friendly initially than Docker

And difficult to integrate into the non-nix world

</v-clicks>

---
layout: center
---

# Nix vs Docker

<br/>

So which is better?

<v-clicks>

That depends on your use case

IMO both!

```nix
{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
  name = "cowsay-container";
  config = {
    Cmd = [ "${pkgsLinux.cowsay}/bin/cowsay" "I'm a container" ];
  };
}
```

</v-clicks>

---
layout: center
---

![](/images/reproducible.jpg)

---
layout: center
---

# NixOS

---

# NixOS

<br/>

A Linux distribution built on top of the Nix ecosystem

<v-clicks>

The whole OS is totally declarative

From the kernel version to your vimrc or vscode extensions

Atomic rollbacks and upgrades

Entire dependency can be graphed and visualized - `nix-tree`

Everything can be version controlled on github

Nixpkgs provides a "module" system for a transparent and declarative setup

I won't digress too much but will show a few examples

</v-clicks>

---
layout: center
---

# NixOS

<br/>

How `bluetooth` might be configured:


```nix
{
  hardware.bluetooth = {
    enable = true;
    settings = { General.Enable = "Source,Sink,Media,Socket"; };
  };
  services.blueman.enable = true;
}
```

---
layout: center
---

# NixOS

<br/>

How `geth` might be configured:


```nix
{
  services.geth = {
    mainnet = {
      enable = true;
      http = {
        enable = true;
        apis = [ "net" "eth" "debug" "engine" "admin" ];
        port = 8545;
      };
      authrpc = {
        enable = true;
      };
      metrics.enable = false;
      syncmode = "full";
      package = pkgs.unstable.go-ethereum.geth;
    };
  };
}
```

---
layout: center
---

# NixOS

<br/>

How `python` is installed:

```nix
let
  pythonPkgs = pkgs.python310.withPackages
    (p: with p; [ black poetry pip cython pytest nose pyflakes isort ]);
in {
  environment.systemPackages = with pkgs; [
    pythonPkgs
    python-language-server
    nodePackages.pyright
    pipenv
  ];
}
```

---
layout: center
---

# Other areas

<v-clicks>

- Nix Profiles
- NixOps/nix deployment tooling
- NixOs Modules
- Nix CI
- Nix Overlays
- Nix Secrets management
- Nixpkgs Overriding Packages
- Nix builders
- ...... and so on

</v-clicks>

---
layout: center
---

The Nix world is complex, a lot of stuff

<v-clicks>

And is slowly maturing out of a research/experimental idea

But I think it's really innovating

It is a huge leap forward in how developers can build reproducibile and reliable systems

Just needs more adoption and more maturity

</v-clicks>
