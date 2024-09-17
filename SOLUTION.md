## Step 1: Write a Dockerfile

The first line, FROM node:lts-alpine, tells Docker to base the container on a special version of Node.js called "Alpine." Alpine is a super lightweight Linux distribution, which means the final Docker image will be small, saving space and making deployments faster. You’re using the Long-Term Support (LTS) version of Node, which is stable and reliable for production use.
Next, ENV NODE_ENV=production sets an environment variable that tells Node.js and any libraries you use to behave in "production mode." This is important because in production mode, the app runs more efficiently—features meant for development, like logging or debugging tools, are disabled, making the app faster and leaner.
The command WORKDIR /usr/src/app sets up a working directory inside the container where the app will live. This is like creating a folder on the computer where the project will be stored. Any commands after this point (like copying files or installing dependencies) will happen inside this directory.
With the COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"] command, you’re copying over the package.json and related files into the container. These files list the dependencies (third-party libraries) the app needs to work. You’re not copying the entire app yet, just enough to install dependencies.
The next line, RUN npm install --production --silent && mv node_modules ../, tells the container to install only the production dependencies (using npm install --production). It skips development dependencies, like testing tools, because you don’t need those in production. The mv node_modules ../ moves the node_modules folder one level up, out of the main app directory. This is to keep it out of the way when you copy the rest of the app in the next step.
Now, you use COPY . . to copy the entire source code of the app from the local machine into the container. Since the node_modules directory was moved out of the way earlier, it won’t be accidentally overwritten here.
By running EXPOSE 3000, you’re telling Docker that the app will listen for incoming requests on port 3000. This is the default port many Node.js apps use, but this line is more of a note to anyone reading the Dockerfile or running the container—they still have to map it to a real port when running the container.
The RUN chown -R node /usr/src/app command changes the ownership of all the files in the app directory to the node user, which is a predefined non-root user that comes with the Node.js image. This is a security measure to make sure that the app doesn’t run with unnecessary root-level privileges.
The USER node command tells Docker that from this point forward, all commands inside the container should be run by the node user instead of the root user. Running containers as non-root users is a best practice because it reduces the risk of security vulnerabilities.
Finally, CMD ["npm", "start"] is the command that gets executed when the container starts up. It’s equivalent to typing npm start in the terminal, which usually kicks off the main application. In most cases, the start script in the package.json will start the web server so it can respond to requests.

## Step 2: Build the Docker Image

```
docker build -t devops-webapp .
```

## Step 3: Check the Image

```
docker images
```

## Step 4: Run the Docker Container

```
docker run -d -p 3000:3000 e1451e72da0e
```

## Step 5: Stop the Docker Container

```
docker ps
docker stop clever_ptolemy
```

## Step 6: Add Github Actions

Create linter.yml, build.yml and audit.yml

## Step 7: Create Private Docker Repository / Add Github Action for Docker Image

Sign in to DockerHub and create a private repository
{dockerUserName}/devops
Add Repository secrets for Docker in Github (Security/Secrets and variables/Actions)
Create release.yml
