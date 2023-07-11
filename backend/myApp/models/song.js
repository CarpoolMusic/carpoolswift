const Song = function(songID, name, artist, addedBy) {
    this.songID = songID;
    this.name = name;
    this.artist = artist;
    this.addedBy = addedBy;
    this.votes = 0;
}

module.exports = Song;