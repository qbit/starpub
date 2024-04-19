-- name: GetUserCategories :many
SELECT
    *
FROM
    categories
WHERE
    user_id = $1;

-- name: GetUserEntries :many
SELECT
    *
FROM
    entries
WHERE
    user_id = $1;

-- name: CreateUser :one
INSERT INTO users (
	  real_name, username, pubkey
) VALUES (
  $1, $2, $3
)
RETURNING id, username, pubkey;

-- name: SimilarEntries :many
SELECT
    id,
    similarity(descr, $2) AS similarity,
    ts_headline(
        'english',
        descr,
        q,
        'StartSel = <b>, StopSel = </b>'
    ) :: text AS headline,
    title
FROM
    entries,
    to_tsquery($2) q
WHERE
    user_id = $1
    AND similarity(descr, $2) > 0.0
    AND similarity(descr, $2) < 1.0
ORDER BY
    similarity DESC
LIMIT
    10;

-- name: GetEntryCategories :many
SELECT
    *
FROM
    categories
WHERE
    id IN (
        SELECT
            category_id
        FROM
            entry_categories a
        WHERE
            a.entry_id = $1
            AND a.user_id = $2
    );

-- name: GetUser :one
SELECT
    *
FROM
    users
WHERE
    id = $1
LIMIT
    1;

-- name: GetUserByName :one
SELECT
    *
FROM
    users
WHERE
    username = $1
LIMIT
    1;

-- name: CreateEntry :one
INSERT INTO entries (
	  user_id, title, descr
) VALUES (
  $1, $2, $3
)
RETURNING id, created_at, to_tsvector(descr);
