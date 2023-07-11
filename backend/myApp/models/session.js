const uuid = require('uuid');

class Session {
  constructor(hostId) {
    this.hostId = hostId;
    this.sessionId = uuid.v4();
    this.members = new Set();
    this.queue = []; // The queue of songs
  }

  join(socketId) {
    this.members.add(socketId);
  }

  remove(socketId) {
    this.members.delete(socketId);
  }

  isMember(socketId) {
    return this.members.has(socketId);
  }

  isHost(socketId) {
    return this.hostId == socketId;
  }

  addSong(song) {
    this.queue.push(song);
  }

  removeSong(songId) {
    this.queue = this.queue.filter(song => song.songID !== songId);
  }

  voteOnSong(songId, vote) {
    let song = this.queue.find(song => song.songID === songId);
    if(song) {
      song.votes += vote; // assumes 'vote' is 1 for upvote, -1 for downvote
    }
  }
}

module.exports = Session;