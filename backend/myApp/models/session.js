const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize('musicqueuedb', 'nolb', '', {
  host: 'localhost',
  dialect: 'postgresql'
});

const Session = sequelize.define('Session', {
  id: {
    type: DataTypes.UUID,
    defaultValue: Sequelize.UUIDV4, // Or Sequelize.UUIDV1
    primaryKey: true
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  // Add other fields as needed
});