---
title: MultiIndexable Slicing
date: 2022-05-014T16:31:22-07:00
---

# MultiIndexable Slicing
In Phase, slicing multidimensional arrays
([`MultiIndexables`](https://phase.blog/api/Phase/MultiIndexable.html)s) is
designed to be very similar to [slicing ordinary arrays]( {{< relref
"/crystal_slicing_mechanisms" >}} ). In fact, for single-dimensional
`MultiIndexables`, slicing is almost identical:

```crystal
require "phase"

include Phase

# Vanilla crystal slicing:
arr = ['a', 'b', 'c', 'd']
arr[1..] # => ['b', 'c', 'd']

# 1D MultiIndexable slicing:
narr = NArray['a', 'b', 'c', 'd']
narr[1..] # => NArray['b', 'c', 'd']
```

## Basic Example
When we add another dimension, we must specify two sets of indexes. In
one dimension, slicing is like cutting a line of elements out of a longer line.
In 2D, slicing is like cutting a small square of elements out of a larger sheet,
and so on for n-dimensional volumes. For example:

```crystal
require "phase"

include Phase

# Create a 2D matrix of elements
narr = NArray[[:a, :b, :c, :d],
              [ 1,  2,  3,  4],
              [:e, :f, :g, :h]]

# Take row 0 and 1, columns 1 and 2:
narr[0..1, 1..2] # => NArray[[:b, :c],
                 #           [ 2,  3]]
```

## Regions & Chunks
In the familiar array paradigm, an *index* is a number that points at an *element*
of the array. In high level languages like Crystal, we've seen that this can be
extended further - a *range of indices* can point at a *list of elements*, like
`arr[1..]` as seen earlier.

Although it is possible to describe everything that Phase does using this
one-dimensional language, it gets tedious pretty quickly. In Phase, we refer to
a collection of indices as a *coordinate* and a collection of *coordinates* as a *region*.

Finally, in the same way that an index points to an element - a *region* points
to a *chunk* of elements from the `MultiIndexable`.

To connect this to the previous example:

```crystal
require "phase"

include Phase

# This NArray is made of *elements* located at *coordinates*
narr = NArray[[:a, :b, :c, :d],
              [ 1,  2,  3,  4],
              [:e, :f, :g, :h]]

# For example, the :b is located at coordinate [0, 1]:
narr.get(0, 1) # => :b

# To take row 0, 1, and columns 1, 2, we want to select the coordinates
# [0, 1], [0, 2], [1, 1], and [1, 2]. We denote this using the ranges
# as a shorthand - the collection of coordinates described here describes
# a *region*
region = [0..1, 1..2]

# Now, we can use this *region* to get a *chunk*:
narr[region] # => NArray[[:b, :c],
             #           [ 2,  3]]
```

## Implicit Syntax
It can get tedious to type out `..` over and over. Phase will automatically fill out
a region with `..` until the correct number of dimensions is reached for a slicing
operation:

```crystal
require "phase"

include Phase

narr = NArray[[:a, :b, :c, :d],
              [ 1,  2,  3,  4],
              [:e, :f, :g, :h]]

# Select rows 1 and 2 with all columns:
narr[0..1, ..] # => NArray[[:a, :b, :c, :d], [1, 2, 3, 4]]

# Identically, use the implicit syntax:
narr[0..1] # => NArray[[:a, :b, :c, :d], [1, 2, 3, 4]]

# Phase will add `..` to the right side: [0..1] => [0..1, ..]
# This also works for any number of dimensions. In a 5D array,
# narr[0..3, 2] == narr[0..3, 2, .., .., ..]
```

## Dimension Dropping
It is often the case that you'll want to select a simple chunk from a higher-dimensional
data structure - for example, a single row from a matrix, or a single color channel from
an image. This is distinct from dimension-preserving cases, because you will specify an
integer, not a range, in one or more of the ordinates:

```crystal
require "phase"

include Phase

narr = NArray[[1, 2],
              [3, 4]]

# Here, the 0 is an integer, not a range. Phase will strip a dimension
# off of the result, as shown - we get a 1D NArray from the 2D matrix `narr`.
first_row = narr[0, ..] # => NArray[1, 2]

# By counterexample, we can select the first row *as a matrix* by using a
# single-index range:
first_row_as_matrix = narr[0..0, ..] # => NArray[[1, 2]]
```

This also explains the use of
[`MultiIndexable#get`](https://phase.blog/api/Phase/MultiIndexable.html#get%28%2Atuple%29-instance-method)
in an earlier example. Slicing can drop dimensions, but it cannot change the
return type. So, `narr[region]` will *always* return an `NArray`, regardless of
the region you pass - even if it might seem counterintuitive:

```crystal
require "phase"

include Phase

narr = NArray[[1, 2], [3, 4]]

# Let's extract the top left element:
narr[0, 0] # => NArray[1]
```

In the example shown, even though we've removed all the dimensions (we used fully integer coordinates),
the return type cannot be changed to `Int32` as you might expect. The `#get` method has a different
method signature, and thus can return the element inside directly:

```crystal
narr.get(0, 0) # => 1
```

Alternatively, you can convert a single-element `MultiIndexable` to a scalar
type using
[`#to_scalar`](https://phase.blog/api/Phase/MultiIndexable.html#to_scalar%3AT-instance-method):

```crystal
# This is a worse choice than using #get for many reasons, but it is useful at times.
narr[0, 0].to_scalar # => 1

# This method also allows you to extract the sole element of a multidimensional structure:
deep_scalar = NArray[[[[1]]]]
deep_scalar.to_scalar # => 1

# The above is easier than deep_scalar.get(0, 0, 0, 0)
```

In certain use cases (typically when the region is passed to you by other, unknown code),
you may want to disable dimension dropping. This can be done with an optional parameter:

```crystal
rqeuire "phase"

include Phase

def must_return_2d_matrix(region)
  narr = NArray[[1, 2],
                [3, 4]]

  return narr[region, drop: false]
end

# Even though the region literal we're passing uses an integer index,
# `drop: false` ensures that the output is the same number of dimensions
# as `narr`.
must_return_2d_matrix([0, ..]) # => NArray[[1, 2]]
```

## Step Size
Unfortunately, Crystal's ranges don't support step sizes in the literal like, for example,
Python (`array[0:5:2]`). However, Crystal's flexibility enables a similarly simple syntax:

```crystal
require "phase"

import Phase

narr = NArray[[:a, :b, :c, :d],
              [ 1,  2,  3,  4],
              [:e, :f, :g, :h]]

# Start at row zero, step by two, and select all columns implicitly:
narr[0..2..] # => NArray[[:a, :b, :c, :d], [:e, :f, :g, :h]]
```

Note that, unlike Python's slice syntax, which has the order `start:stop:step`,
Phase uses the more natural order `start..step..stop`.

You can also use a triple-dot (`...`) before the final index, rather than a
`..`, to make the stop value exclusive:

```crystal
narr[0..2..2] # => NArray[[:a, :b, :c, :d], [:e, :f, :g, :h]]
narr[0..2...2] # => NArray[[:a, :b, :c, :d]]

# Note that the ellipsis before the step size is totally ignored.
# narr[start..step..stop] always equals narr[start...step..stop]
```

Under the hood, this stepped range syntax is admittedly a little hacky, but
it's convenient enough that we opted to stick with it. (If you're curious how
this works, `0..2..5` is actually equivalent to `(0..2)..5`, which is the
literal for an instance of `Range(Range(Int, Int), Int)`. When Phase dissects
the region you pass, it notices objects with that type (or the related type,
`Range(Int, Range(Int, Int))`), and breaks it down into the start, step, and
stop indexes.)
