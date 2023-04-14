const visit = require("unist-util-visit");

module.exports = function remarkSkipMaterialAdmonitions() {
  const SKIP_ADMONITION = /^!!!\s/;

  function visitor(node, index, parent) {
    if (node.type === "text" && SKIP_ADMONITION.test(node.value)) {
      const lines = node.value.split("\n");

      const admonitionLine = lines.shift();
      const rest = lines.join("\n");

      const admonitionNode = {
        type: "raw",
        value: admonitionLine,
      };

      if (rest.length > 0) {
        const newTextNode = {
          ...node,
          value: rest,
        };
        parent.children.splice(index + 1, 0, newTextNode);
      }

      node.type = admonitionNode.type;
      node.value = admonitionNode.value;
    }
  }

  return (tree) => {
    visit(tree, "text", visitor);
  };
};
