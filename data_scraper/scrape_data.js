var gplay = require('google-play-scraper');
var fs = require('fs');
var util = require('util');

var interval = 10000; // how much time should the delay between two iterations be (in milliseconds)?
var promise = Promise.resolve();

util.inspect.defaultOptions.maxArrayLength = null;

const categories = { 
  APPLICATION: gplay.category.APPLICATION,
  ANDROID_WEAR: gplay.category.ANDROID_WEAR,
  ART_AND_DESIGN: gplay.category.ART_AND_DESIGN,
  AUTO_AND_VEHICLES: gplay.category.AUTO_AND_VEHICLES,
  BEAUTY: gplay.category.BEAUTY,
  BOOKS_AND_REFERENCE: gplay.category.BOOKS_AND_REFERENCE,
  BUSINESS: gplay.category.BUSINESS,
  COMICS: gplay.category.COMICS,
  COMMUNICATION: gplay.category.COMMUNICATION,
  DATING: gplay.category.DATING,
  EDUCATION: gplay.category.EDUCATION,
  ENTERTAINMENT: gplay.category.ENTERTAINMENT,
  FINANCE: gplay.category.FINANCE,
  FOOD_AND_DRINK: gplay.category.FOOD_AND_DRINK,
  HEALTH_AND_FITNESS: gplay.category.HEALTH_AND_FITNESS,
  HOUSE_AND_HOME: gplay.category.HOUSE_AND_HOME,
  LIFESTYLE: gplay.category.LIFESTYLE,
  MAPS_AND_NAVIGATION: gplay.category.MAPS_AND_NAVIGATION,
  MEDICAL: gplay.category.MEDICAL,
  MUSIC_AND_AUDIO: gplay.category.MUSIC_AND_AUDIO,
  NEWS_AND_MAGAZINES: gplay.category.NEWS_AND_MAGAZINES,
  PARENTING: gplay.category.PARENTING,
  PERSONALIZATION: gplay.category.PERSONALIZATION,
  PHOTOGRAPHY: gplay.category.PHOTOGRAPHY,
  PRODUCTIVITY: gplay.category.PRODUCTIVITY,
  SHOPPING: gplay.category.SHOPPING,
  SOCIAL: gplay.category.SOCIAL,
  SPORTS: gplay.category.SPORTS,
  TOOLS: gplay.category.TOOLS,
  TRAVEL_AND_LOCAL: gplay.category.TRAVEL_AND_LOCAL,
  VIDEO_PLAYERS: gplay.category.VIDEO_PLAYERS,
  WEATHER: gplay.category.WEATHER,
  GAME: gplay.category.GAME,
  GAME_ACTION: gplay.category.GAME_ACTION,
  GAME_ADVENTURE: gplay.category.GAME_ADVENTURE,
  GAME_ARCADE: gplay.category.GAME_ARCADE,
  GAME_BOARD: gplay.category.GAME_BOARD,
  GAME_CARD: gplay.category.GAME_CARD,
  GAME_CASINO: gplay.category.GAME_CASINO,
  GAME_CASUAL: gplay.category.GAME_CASUAL,
  GAME_EDUCATIONAL: gplay.category.GAME_EDUCATIONAL,
  GAME_MUSIC: gplay.category.GAME_MUSIC,
  GAME_PUZZLE: gplay.category.GAME_PUZZLE,
  GAME_RACING: gplay.category.GAME_RACING,
  GAME_ROLE_PLAYING: gplay.category.GAME_ROLE_PLAYING,
  GAME_SIMULATION: gplay.category.GAME_SIMULATION,
  GAME_SPORTS: gplay.category.GAME_SPORTS,
  GAME_STRATEGY: gplay.category.GAME_STRATEGY,
  GAME_TRIVIA: gplay.category.GAME_TRIVIA,
  GAME_WORD: gplay.category.GAME_WORD
  }

function write_to_file(cat, d) {
	fs.appendFile(__dirname + '\\data\\' + cat + '.dat', util.format(d), function (err) {
	  if (err) throw err;
	  console.log('\t- [FINISH]\tCategory: ' + cat);
	});
}

function write_to_error(cat, d) {
	fs.appendFile('error.log', '[ERROR] Category: ' + cat + '\n' + util.format(d) + '\n', function (err) {
	  if (err) throw err;
	});
}

for (const index in categories) {
	promise = promise.then(function () {
		console.log(' + [START]\tCategory: ' + categories[index]);
		gplay.list({
			category: categories[index],
			collection: gplay.collection.GROSSING,
			fullDetail: true,
			throttle: 5,
			num: 200
		  })
		  .then((d) => {write_to_file(categories[index], d)}, (d) => {write_to_error(categories[index], d)});
		return new Promise(function (resolve) {
		  setTimeout(resolve, interval);
		});
	});
}