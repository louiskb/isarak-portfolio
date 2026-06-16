class BackfillResearchItemPositionsByDate < ActiveRecord::Migration[8.1]
  # One-time backfill so the index defaults to newest-publication-first.
  # Ongoing re-sorting is handled by ResearchItem.sort_by_recency! (the
  # "Sort by most recent" button), which this migration reuses.
  def up
    ResearchItem.sort_by_recency!
  end

  def down
    # No-op: leaving positions in place is harmless.
  end
end
