/**
 * Application Javascript for Dánlann
 *
 * (c) 2009 Bryan JJ Buckley
 * Distributed under a Ruby like licence - see
 *   http://danlann.rubyforge.org/COPYING
 */

/**
 * The Application is the function that ensures the right behaviour is applied
 * to the right elements.
 */
Application = function() {
  /* Apply a mask to make file fields look pretty cross-platform */
  $$("input[type=file]").each(function(field) {
    name = id = field.id + '_mask';
    class_name = "file_mask";
    value = field.value;
    html = '<input type="text"' +
      '" name="' + name +
      '" id="' + id +
      '" class="' + class_name +
      '" value="' + value +
      '" style="z-index:-1" />';
    field.absolutize();
    field.insert({ before: html });
    field.setOpacity(0);
    field.observe("change", function(e) {
      mask = $(e.element().id + "_mask");
      mask.value = e.element().value;
    });
  });
  // apply Hacks
  // assign Autocompleters
  // assign Observers
};

// Apply the behaviour
document.observe('dom:loaded', Application);

// vi:ft=javascript:tw=79:ts=2:sw=2
