describeComponent('search/results_highlighter', function () {
  'use strict';

  it('highlights words or parts of words that match with the keywords given', function () {
    this.setupComponent('<div id="text">Any one seeing too many open bugs</div>');

    this.component.attr = {keywords: ['any']};
    this.component.highlightResults(event, {where: '#text'});

    var highlightedWords = this.component.$node.find('.search-highlight').length;

    expect(highlightedWords).toEqual(2);
  });

  it('resets highlights when a new search is performed', function() {
    this.setupComponent('<div id="text">Any one seeing too many open bugs</div>');

    this.component.attr = {keywords: ['any']};
    this.component.highlightResults(event, {where: '#text'});
    $(document).trigger(Pixelated.events.search.resetHighlight);

    var highlightedWords = this.component.$node.find('.search-highlight').length;

    expect(highlightedWords).toEqual(0);
  });
});
