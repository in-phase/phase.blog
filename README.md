# Phase Website

## Setup
This repo uses several submodules. After cloning, run:
```sh
git submodule update --init --recursive
````

## Development
There are several ways to preview your work as you go.
To work on one of the hugo sites, cd into its folder and run
`hugo serve --disableFastRender`.

## Development Notes
- If a post is labeled with `draft: true` in the frontmatter, hugo will just pretend it doesn't exist, and this makes debugging very painful sometimes.
- Make sure to use `--disableFastRender` if using `hugo serve` - some elements will not regenerate (e.g. the menu on the reference docs)
