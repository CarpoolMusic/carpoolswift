const Song = function(id, title, artworkURL, artist, addedBy) {
    this.id = id;
    this.title = title;
    this.artworkURL = artworkURL
    this.artist = artist;
    this.votes = 0;
    this.addedBy = addedBy;
}

module.exports = Song;