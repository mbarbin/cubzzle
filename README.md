# cubzzle

[![Actions Status](https://github.com/mbarbin/cubzzle/workflows/CI/badge.svg)](https://github.com/mbarbin/cubzzle/actions/workflows/ci.yml)
[![Deploy odoc Actions Status](https://github.com/mbarbin/cubzzle/workflows/Deploy-odoc/badge.svg)](https://github.com/mbarbin/cubzzle/actions/workflows/deploy-odoc.yml)

This is a toy project implementing a brute force solver for a small
wooden puzzle that I use to have at home.

## What's the puzzle ?

There are 6 wooden pieces made of small cubes that can fit into a
3x3x3 box.

![The puzzle](images/puzzle.png)

## What does the solver do ?

The solver finds a solution and displays it in a Graphics window.

![The cube](images/cube.png)

So that one can see exactly how the pieces fit, the display allows for
inspecting pieces individually.

![The cube help](images/cube-help.png)

## Other shapes

You can assemble the same pieces into other shapes as well, such as a Dog:

![The dog](images/dog.png)

or a Tower, etc.

![The tower](images/tower.png)

## Running the code interactively

To run the solver in the terminal, make sure you've build first:

```bash
make
```

Then run the following command:

```bash
$ dune exec cubzzle -- run
```

A few shapes are available (Cube, Dog, Tower, etc.). To solve a
different shape, provide the option `-shape`. You can also draw the
box during the brute force search, to see the solver run through all
permutations interactively.

```bash
$ dune exec cubzzle run -- -shape Tower -draw-box-during-search true
```

## Motivations

I wanted to have a small project on GitHub that would use the OCaml
Graphics library, as a code sample.

## Code documentation

The tip of the master branch is compiled with odoc and published to
github pages
[here](https://mbarbin.github.io/cubzzle/odoc/cubzzle/index.html).
