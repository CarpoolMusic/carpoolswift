const uuid = require('uuid');

class Session {
  constructor(hostId) {
    this.hostId = hostId;
    this.sessionId = uuid.v4();
    this.members = new Set();
    this.queue = []; // The queue of songs
  }

  join(userId) {
    this.members.add(userId);
  }

  remove(userId) {
    this.members.delete(userId);
  }

  isMember(userId) {
    return this.members.has(userId);
  }

  ishost(userId) {
    return this.host !== userId;
  }

  addSong(song) {
    this.queue.push(song);
  }

  removeSong(songId) {
    this.queue = this.queue.filter(song => song.id !== songId);
  }

  voteOnSong(songId, vote) {
    const song = this.queue.find(song => song.id === songId);
    if(song) {
      song.voteCount += vote; // assumes 'vote' is 1 for upvote, -1 for downvote
    }
  }
}

module.exports = Session;