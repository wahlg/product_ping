module.exports = {
  apps : [{
    name: 'product_worker',
    script: 'bundle exec rake products:ping',
    exec_mode: 'fork_mode',
    watch: false
  }],
};
