# Part 2

(Back up in case notebook took too long to render)

I listed a few inputs:

| N   | g(N) |
| --- | ---- |
| 1   | 0    |
| 7   | 1    |
| 17  | 2    |
| 27  | 3    |
| 69  | 7    |
| 70  | 8    |
| 71  | 9    |
| 72  | 10   |
| 170 | 27   |

Plus, here is my observation:

Given a number K, if K % 10 == 7, then K contains a 7 digit.
Else, divide K by 10 and try again while K > 0.

So I wrote a program first:

```ruby
def g(n)
  count = 0
  1.upto(n) do |num|
    while num.positive?
      if num % 10 == 7
        count+=1
        break
      end

      num/=10
    end
  end
  count
end
```

# Answer to Question 1

```ruby
puts g(1000)
#= => 271
```

# Answer to Question 2

This is my implementation:

```ruby
def g(n)
  count = 0
  1.upto(n) do |num|
    while num.positive?
      if num % 10 == 7
        count+=1
        break
      end

      num/=10
    end
  end
  count
end
```

## Analysis of my program

### Time Complexity: $O(n logn)$

$\qquad \overbrace{O(n)}^{\mathclap{\text{Loop from 1..n} }} \quad \cdot \quad \overbrace{O(\log\_{10} {n})}^{\mathclap{\text{divide by 10 until} \lt 1}} $

### Space Complexity: $O(1)$

No extra spaces used.
