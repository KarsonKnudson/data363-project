'use strict';

const R = require('ramda');
const debug = require('debug')('google-play-scraper:mappers:details');
const cheerio = require('cheerio');

const MAPPINGS = {
  // FIXME add appId
  title: ['ds:5', 0, 0, 0],
  installs: ['ds:5', 0, 12, 9, 2],
  genre: ['ds:5', 0, 12, 13, 0, 2],
  icon: ['ds:5', 0, 12, 1, 3, 2]
};

function descriptionText (description) {
  // preserve the line breaks when converting to text
  const html = cheerio.load('<div>' + description.replace(/<br>/g, '\r\n') + '</div>');
  return cheerio.text(html('div'));
}

function priceText (priceText) {
  return priceText || 'Free';
}

function normalizeAndroidVersion (androidVersionText) {
  const number = androidVersionText.split(' ')[0];
  if (parseFloat(number)) {
    return number;
  }
  return 'VARY';
}

function buildHistogram (container) {
  if (!container) {
    return { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
  }
  return {
    1: container[1][1],
    2: container[2][1],
    3: container[3][1],
    4: container[4][1],
    5: container[5][1]
  };
}

/**
 * Extract the comments from google play script array
 * @param {array} comments The comments array
 */
function extractComments (comments) {
  if (!comments) {
    return [];
  }

  debug('comments: %O', comments);

  return R.compose(
    R.take(5),
    R.reject(R.isNil),
    R.pluck(4))(comments);
}

module.exports = MAPPINGS;
