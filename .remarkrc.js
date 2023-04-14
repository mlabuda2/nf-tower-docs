module.exports = {
    plugins: [
      ['remark-frontmatter', {type: 'yaml', marker: '---'}],
      'remark-preset-lint-recommended',
      'remark-gfm',
      ['remark-lint-list-item-indent', 'space'],
      'remark-validate-links',
      'remark-admonitions',
      require('./remark-skip-material-admonitions'),
      {
        resolve: 'remark-lint',
        options: {
          'strong-marker': '*',
          'emphasis-marker': '_',
          'list-item-indent': 'space',
          'no-emoji': true,
          'no-inline-padding': true,
          'tab-width': 4,
        },
      },
    ],
  };
  