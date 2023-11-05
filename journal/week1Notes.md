### S3 buckets hold things
Remember, bucket names are in the global name space, they must be unique.
Global namespace means that we can't name our bucket the same name as someone else's bucket. But each cloud provider has it's own naming rules.
s3 buckets are global, but you set a region on the bucket
BC the namespace is global, but the storage is regional

### Chris holding down the fort with some security knowledge
Choose a region so that you know what hard drive it is written to
Block public access means that others can't access your bucket
Keep your buckets locked down
Bucket versioning is good to use
It helps you to add a new version each time that you add.
If someone gets into account, they can only delete up to a certain point.
We are storing back end state in TF Cloud so that it is versioned and protected. 
This will keep your ARN's secure!
Make sure that your state file is unavailable to the outside!
TF Cloud has tons of security! If you are using S3 to store instead of TF Cloud, have bucket versioning on bc every change to the state file will be tracked.


### npm install --global http-server
to get our server running
then `http-server` to get it running

### aws cli
Want to see your buckets?
`aws` will bring up a menu, go from there!
```sh
gitpod /workspace/terraform-beginner-bootcamp-2023 (main) $ aws s3
> aws s3 ls
2023-09-11 22:55:26 redacted bucket name
2023-10-23 03:35:32 redacted bucket name

```

Now let's send our index.html to an s3 with the below command:
```sh
ws s3 cp public/index.html s3://redactedBucketName/index.html

# This will be the response message
Completed 252 Bytes/252 Bytes (588 Bytes/s) withupload: public/index.html to s3://redactedBucketName/index.html
```

