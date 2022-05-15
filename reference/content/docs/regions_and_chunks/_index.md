---
title: Regions & Chunks
date: 2022-02-02T23:16:22-07:00
---

# Regions & Chunks

## Introduction
At its core, Phase is all about providing an easy to use container for storing
large amounts of data. One of the most important parts of that task is
providing an easy way for the user to extract a peice of data from the
collection - for example, selecting only the first three elements from a
vector, or isolating the green channel of an RGB image.

Although it seems very simple, this topic can get quite confusing. Because
Phase aims to make scientific computing easier to work with, we're devoting
a whole section to this one operation of taking an `NArray` (or, more
specifically, a `MultiIndexable`) apart.

To begin with, we'll review the Array from Crystal's standard library. If
you're comfortable with slicing Arrays in Crystal already, skip to
[MultiIndexable Slicing]({{< relref "/multiindexable_slicing" >}}).
