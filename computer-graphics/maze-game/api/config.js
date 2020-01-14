module.exports = {
  aws_table_name: 'maze_statistic',
  aws_local_config: {
    region: 'local',
    endpoint: 'http://localhost:8000'
  },
  aws_remote_config: {
    accessKeyId: '...',
    secretAccessKey: '...',
    region: 'us-east-1',
  }
};
