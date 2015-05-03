console.log Posts.find!.count!
for post in Posts.find!
  console.log post
Template.postsList.helpers posts:-> Posts.find()