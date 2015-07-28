$(function() {
  $('.method-details__name').each(function(i, el) {
    var subtopic = $(el).data('subtopic');
    var $a = $(el).find('a');
    var anchorText = $.trim($a[0].innerHTML);

    if (anchorText === '') {
      return;
    }

    var $row = $('#quicklinks');
    var $link = $('<a/>', {
      href: '#'+$(el).attr('name')
    }).html(anchorText);

    $('<li>').append($link).appendTo($row);
  });

  $('#content pre').each(function(i, block) {
    var code;
    var $block = $(block);
    var $codeEl = $block.find('> code');

    // RedCarpet markdown renderer will convert fenced code blocks into
    // <pre><code>...</code></pre> and we want to remove that <code /> el and
    // use a plain <pre /> instead:
    if ($block.children().length === 1 && $codeEl.length) {
      code = $codeEl.text();
      $codeEl.remove();
      $block.html(code);
    }

    hljs.highlightBlock(block);
  });

  // Make it so that clicking one of these "tabs" for every @example_request
  // dialect switch to that dialect's example. For example: switching between
  // the generated JSON and cURL examples when those anchors are clicked.
  $('.example-codeblocks__tabs').each(function() {
    var $examples = $(this).siblings('.example-codeblocks__example');

    $(this).find('a').each(function(index) {
      var $example = $examples.eq(index);

      $(this).on('click', function() {
        $examples.hide().removeClass('active');
        $example.show().addClass('active');

        $(this).siblings('a.active').removeClass('active');
        $(this).addClass('active');
      });
    });
    
    $(this).find('a:first').click();
  });
});