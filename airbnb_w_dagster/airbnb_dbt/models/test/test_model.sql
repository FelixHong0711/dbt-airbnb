WITH test_src_reviews AS (
    SELECT * FROM {{ref("src_reviews")}}
)
SELECT * FROM test_src_reviews