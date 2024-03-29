const railsEnv = process.env.RAILS_ENV
const environment = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}

if (railsEnv === 'development' || railsEnv === 'production') {
  environment.plugins.push(
    require('@fullhuman/postcss-purgecss')({
      content: [
        './app/**/*.html.haml',
        './app/**/*.html.erb',
        './app/helpers/*.rb',
        './app/javascript/controllers/**/*.js'
      ],
      safelist: {
        standard: [/^(ct-|tooltip|mapbox|collaps|modal)/]
      },
      defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:]+/g) || []
    })
  )
}

module.exports = environment
