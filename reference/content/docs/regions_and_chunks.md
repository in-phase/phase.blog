---
title: Regions &amp; Chunks
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
[Adding Dimensions](#adding-dimensions).

## Arrays in One Dimension
In an Array, each element is represented by a numeric index. There are a couple
different ways to do this - we can refer to the elements via positive,
increasing indexes as such:

```crystal
arr = ['P', 'h', 'a', 's', 'e']
#       0    1    2    3    4

arr[0] # => 'P'
arr[4] # => 'e'
```

Or, we can start at the other end of the array using negative indexes:

```crystal
arr = ['P', 'h', 'a', 's', 'e']
#      -5   -4   -3   -2   -1

arr[-1] # => 'e'
arr[-5] # => 'P'
```

But the real complication arises when we want to select _multiple_ elements
from one array. In Crystal, this is done with a Range, often created with a
range literal. A Range describes an ordered collection of indexes by a starting
and ending index. Let's construct a Range and see what indexes it refers to:

```crystal
# Create a range that starts at 0, and ends at 3 (including 3)
range = Range.new(begin: 0, end: 3, exclusive: false)
range.to_a # => [0, 1, 2, 3]
```

So, the range we created starts at 0, increments by 1 until it gives us 3,
and then ends. Note that we specified `exclusive: false`, in that example.
It's often useful to exclude the last value (in the example here, 3). Here's
an example:

```crystal
# Create a range that starts at 0, and ends at 3 (excluding 3)
range = Range.new(begin: 0, end: 3, exclusive: true)
range.to_a # => [0, 1, 2]
```

Of course, the syntax shown above is very painful to type out. Instead,
we use range literal syntax to shorten the expressions:

```crystal
# Inclusive ranges are start..end (two periods are used)
inclusive_range = 0..3
inclusive_range.to_a # => [0, 1, 2, 3]

# Exclusive ranges use three periods: 0...3
exclusive_range = 0...3
exclusive_range.to_a #=> [0, 1, 2]
```

Now that we've seen how a range can refer to multiple indexes, it's easy to
use them to sample elements from an array:

```crystal
# Let's extract ['h', 'a', 's'] from this array:
arr = ['P', 'h', 'a', 's', 'e']
#       0    1    2    3    4
# The indexes shown above tell us that we want elements
# 1, 2, and 3. So, we'll construct an appropriate range:

selection_range = 1..3
selection_range.to_a # => [1, 2, 3]

# and use it on the array:
arr[selection_range] # => ['h', 'a', 's']
```

This also works with negative indexes, but the end of the range has to be
positively larger than the starting index:

```crystal
arr = ['P', 'h', 'a', 's', 'e']
#      -5   -4   -3   -2   -1

# Let's extract the last two letters:
selection_range = -2..-1
selection_range.to_a # => [-2, -1]
arr[selection_range] # => ['s', 'e']
```

## Adding Dimensions
