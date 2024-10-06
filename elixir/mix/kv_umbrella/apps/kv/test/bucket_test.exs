defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    # {:ok, bucket} = KV.Bucket.start_link([])
    {:ok, bucket} = start_supervised(KV.Bucket)
    %{bucket: bucket}
  end

  test "stores values by keys", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end
  
  test "it returns deleted value", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)

    assert KV.Bucket.get(bucket, "milk") == 3
    assert KV.Bucket.delete(bucket, "milk") == 3
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "spawns temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end
end
