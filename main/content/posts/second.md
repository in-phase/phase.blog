---
title: "Tutorial: Make Your Own MultiIndexable"
---

# Basics
ph-core offers a standard data type, `Phase::NArray` that will suffice for most of your multidimensional data storage and manipulation needs. However, storing information linearly in memory isn't always the most effective appraoch, and sometimes isn't possible. `Phase::MultiIndexable` is an interface defining a common set of rules we expect any multidimensional array to obey; and by implementing this interface, you can treat your own type almost like an `NArray`.

Let's say we want to be able to access any 5-digit number, using each place value as a coordinate. Since we want our array to return `Int32`s, that will be the type argument.
```crystal
require "ph-core" 

class NumberAccessor < Phase::MultiIndexable(Int32)
end
```

This alone won't compile, because the `MultiIndexable` interface has two abstract methods it expects you to define. So let's do that.

```crystal
require "ph-core" 

class NumberAccessor < Phase::MultiIndexable(Int32)

  def shape
    [10] * 5 # our NumberAccessor is 5-dimensional, with 10 possible values on each axis
  end

  # coord is an Indexable(Int), so we can iterate over it to get each singular *ordinate*.
  # In this example we are treating ordinates as digits of our final number, with 
  # place values corresponding to their position (index) in the coordinate.
  def unsafe_fetch_element(coord) : T
    value = 0
    place_value = 1
    coord.each do |digit|
      value += digit * place_value
      place_value *= 10
    end
  end
end
```
That is technically all we need, and we can now start using our `NumberAccessor`.
```crystal
# examples
```

# Return Types

> **Summary:** there are several methods that return `NArray`s by default, but may be overriden to return your own type:
> - `#unsafe_fetch_chunk(region : IndexRegion)`
> - `#map(&block)`
> - `#map_with(*args, &block)`
> - `.from(other : MultiIndexable)`


# Performance

>**Summary:** there are several methods designed to work for any `MultiIndexable`, at the possible cost of performance. Some we suggest overriding include:
>- Iterator methods: `#fast`, `#each`
>- Transform methods: `#reshape`, `#permute`, `#reverse`
>- `#unsafe_fetch_chunk`
>- `#size`
>
>`Phase::NArray` may offer some inspiration on how these methods work and how they might be optimized.



