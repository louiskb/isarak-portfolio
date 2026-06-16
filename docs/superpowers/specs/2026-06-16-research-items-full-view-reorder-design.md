# Research Items — full one-page reorder view + date-default ordering

**Date:** 2026-06-16
**Status:** Approved (Louis, for Isara)

## Problem

Isara reorders research items on the index via drag-and-drop, but the index is
paginated — he can't drag an item from page 2 to page 1. He also wants the list
to default to **newest publication first** without manual fiddling, and a way to
**reset** the order if he makes a mess.

## Goal

- Keep the paginated index as the **default** view (for visitors and Isara).
- Give Isara a **toggle** into a **full one-page** view: every item on one
  scrollable page, no pagination, easy drag-and-drop across the whole set.
- Add a **"Sort by most recent"** reset that re-stamps order by publication date.
- Make **newest-first by date the default** ordering out of the box.

Ordering stays driven by the existing `position` column (manual drag order).
What changes is that `position`'s *default* is publication date, plus the
full-view toggle and reset button. **The homepage Featured Research logic is not
touched.**

## Design

### Ordering model
The list is ordered by `position` (ascending), exactly as today. `position` is:
- **Initialised** to publication-date order via a one-time backfill migration.
- **Reset** to date order on demand via the "Sort by most recent" button.
- **Overridden** manually whenever Isara drags.

Date order = `published_at DESC NULLS LAST, created_at DESC` (items without a
publication date sink to the bottom, not the top — Postgres defaults nulls first
on DESC, so `NULLS LAST` is explicit).

### Two views (one controller action, `?view=full` query param)
- **Paginated (default):** unchanged. Paginated, ordered by `position`. Visitors
  see published items only; Isara sees all statuses. Drag handles present for Isara.
- **Full one-page (Isara only, `?view=full`):** no pagination, all items ordered
  by `position`, drag-and-drop across everything. Buttons: **Back to paged view**
  and **Sort by most recent** (confirm-guarded — it discards the manual order).

A visitor passing `?view=full` still gets the paginated view (the full branch
requires `user_signed_in?`).

### New items land at the top
On create, the new item gets `position = (min position) - 1` so a freshly added
publication shows first by default instead of sinking to the bottom.

## Components touched

- **Migration** — `BackfillResearchItemPositionsByDate`: stamps existing items'
  positions in date order via `ResearchItem.sort_by_recency!`.
- **Model `ResearchItem`** — `self.sort_by_recency!`: re-stamps every item's
  `position` by date order, in a transaction (`update_columns`, no callbacks).
- **Controller `ResearchItemsController`**
  - `index`: branch on `user_signed_in? && params[:view] == "full"` →
    `@full_view = true`, no pagination; else paginate. Sets `@pagy` only when paginating.
  - `sort_by_recency` (new, auth-guarded): calls `ResearchItem.sort_by_recency!`,
    redirects to `research_items_path(view: "full")` with a notice.
  - `create`: set `position: top_position` on the new item.
- **Routes** — add `patch :sort_by_recency` to the `research_items` collection
  (alongside the existing `reorder`).
- **View `index.html.erb`**
  - Hero buttons (signed-in): paginated view shows "View all on one page";
    full view shows "Back to paged view" + "Sort by most recent".
  - Pagination nav guarded by `if @pagy && @pagy.pages > 1`.
  - Hero hint updated to mention the full-view toggle + reset.

## Testing (Minitest)

- `sort_by_recency` re-ranks positions by `published_at` desc (nulls last); model
  method tested directly.
- `sort_by_recency` requires authentication (visitor → redirected).
- `?view=full` while signed in returns success and renders all items with no
  pagination nav; visitor with `?view=full` still gets the paginated/published list.
- New item is created at the top (lowest `position`).
- Existing `reorder` behaviour still works.

## Out of scope (YAGNI)

- No changes to the homepage Featured Research section.
- No featured-toggle on the manage surface (Isara toggles ★ from each item's edit form).
- No second route/template — the toggle is a query param on the existing index.
