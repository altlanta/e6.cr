# e6.cr

A fast, simple, and easy-to-use e621/e926 client written in Crystal. 

**To clarify the name,** "e6.cr" is the proper name of this lib. However, to prevent redundancy in file naming, the *technical* name is simply "e6". (since `.cr` is the common file extension)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     e6:
       github: altlanta/e6.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "e6"
```

At the moment, the only supported API endpoints are those of the most common user actions, such as listing tags, aliases, flags, posts, and pools. Additionally, it also supports casting votes or faves. However, **creating those common resources (posts, flags, pools, etc.) is not yet implemented.**

## Contributing

1. Fork it (<https://github.com/your-github-user/cr-e6client/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [altlanta](https://github.com/altlanta) - creator and maintainer (not associated with ALTlanta Zine Fest)
