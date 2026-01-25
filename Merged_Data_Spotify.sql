WITH c_index AS(
  SELECT
    *,
      ROW_NUMBER() OVER(
        PARTITION BY country
        ORDER BY user_id
      ) as rn
  FROM spotify.churn
),
p_index AS(
  SELECT
    User_ID,
    Country,
    Top_Genre,
    Listening_Time,
    Repeat_Song_Rate,
      ROW_NUMBER() OVER(
        PARTITION BY Country
        ORDER BY User_ID
      ) as rn
  FROM spotify.preferences
  WHERE Streaming_Platform = "Spotify"
)

SELECT
  c.* EXCEPT(rn),
  p.Top_Genre,
  p.Listening_Time,
  p.Repeat_Song_Rate
FROM c_index AS c
LEFT JOIN p_index AS p
  ON c.country = p.Country
  AND c.rn = p.rn