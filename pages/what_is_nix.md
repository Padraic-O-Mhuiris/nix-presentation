---
clicks: 15
layout: center
---

<div v-if="$slidev.nav.clicks === 0">

# What is Nix?

</div>

<div v-if="$slidev.nav.clicks === 1">

Nix is a _universal_ build system and purely functional package manager

</div>

<div v-if="$slidev.nav.clicks === 2">

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

</div>

<div v-if="$slidev.nav.clicks === 3">

Can be used on any "Unix-Like" systems like Mac and Linux

Install it like so:

```bash
$ sh <(curl -L https://nixos.org/nix/install)
```

</div>

<div v-if="$slidev.nav.clicks === 4">

Also comes in it's own Linux flavour - NixOS (_my daily driver_)

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/NixOS_logo.svg/1280px-NixOS_logo.svg.png)

</div>

<div v-if="$slidev.nav.clicks === 5">

Largest package collection for any package manager, >95K - [_nixpkgs_](https://github.com/NixOS/nixpkgs)

<img src="https://repology.org/graph/map_repo_size_fresh.svg" class="max-w-full max-h-100" alt="..." />

</div>

<div v-if="$slidev.nav.clicks === 6">

Notoriously hard to explain, steep learning curve

<img src="https://discourse.nixos.org/uploads/default/original/2X/f/fef4e7f73fbca41179060500174f1448d16fb8c9.jpeg" class="max-w-full max-h-100" alt="...">

</div>

<div v-if="$slidev.nav.clicks === 7">

I think it's core ideas will form the basis for how software is developed, built and distributed into the future

</div>

<div v-if="$slidev.nav.clicks >= 8 &&  $slidev.nav.clicks < 15">

#### Area's I think Nix could disrupt

<ul>
    <li v-if="$slidev.nav.clicks >= 9">Better alternative to |YOUR OS PACKAGE MANAGER| for all *nix systems</li>
    <li v-if="$slidev.nav.clicks >= 10">Core part of development toolchains, see Replit</li>
    <li v-if="$slidev.nav.clicks >= 11">Replaces the need for centralized package registries, e.g crates.io and npmjs.com</li>
    <li v-if="$slidev.nav.clicks >= 12">Today is already superior to OS configuration tools like Puppet/Ansible/Chef</li>
    <li v-if="$slidev.nav.clicks >= 13">Rival or integrate with Terraform as a cloud provisioning tool</li>
    <li v-if="$slidev.nav.clicks >= 14">Be as pervasive as git in the software developers toolbox</li>
</ul>

</div>

<div v-if="$slidev.nav.clicks === 15">

Into the weeds we go...

</div>
