json.extract! result, :id, :level, :comment, :experiment_id, :hypothesis_id, :created_at, :updated_at
json.url result_url(result, format: :json)