<script>
document.querySelectorAll('.toggle-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    // Toggle active class on buttons
    document.querySelectorAll('.toggle-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    // Show/hide leaderboards
    const target = btn.dataset.target;
    document.getElementById('leaderboard-global').style.display = target === 'global' ? 'block' : 'none';
    document.getElementById('leaderboard-friends').style.display = target === 'friends' ? 'block' : 'none';
  });
});
</script>
