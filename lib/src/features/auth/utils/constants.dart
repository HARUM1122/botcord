const String createBotAccountSteps = """
## To create a Discord bot account, follow these steps:
1. **Create a Discord Application:**
\t - Go to the [Discord Developer Portal](https://discord.com/developers/applications).
\t - Click on the `New Application` button.
\t - Enter a name for your application (this will be the name of your bot).
\t - Click on the `Create` button.

2. **Create a Bot User:**
\t - In your application dashboard, navigate to the `Bot` tab.
\t - Click on the `Add Bot` button.
\t - Confirm the prompt by clicking `Yes, do it!`
\t - You will see a `Token` section. This is your bot's token, which you'll use to authenticate your bot with the Discord API. Keep this token secure, as it grants full access to your bot.

3. **Invite the Bot to Your Server:**
\t - Still in the application dashboard, navigate to the `OAuth2` tab.
\t - Under `OAuth2 URL Generator`, select the `bot` scope.
\t - Scroll down and select the permissions your bot will need. At a minimum, you'll likely want to give it `Send Messages` and `Read Messages` permissions.
\t - Copy the generated URL and open it in your web browser.
\t - Select the server where you want to invite your bot and click `Authorize`.""";

const String endpoint = 'https://discord.com/api/v10';
const String ytVideoLink = 'https://youtu.be/zrNloK9b1ro?si=MRHegbJp6jIrJ2Ft';