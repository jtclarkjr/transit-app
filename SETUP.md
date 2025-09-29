# Transit POC Setup

## API Configuration

This project requires an API base URL to be configured. The URL is not stored in version control for security reasons.

### Option 1: Xcode Environment Variables (Recommended)

1. In Xcode, go to **Product** → **Scheme** → **Edit Scheme...**
2. Select **Run** in the left sidebar
3. Go to the **Arguments** tab
4. Under **Environment Variables**, click the **+** button
5. Add:
   - **Name**: `TRANSIT_API_BASE_URL`
   - **Value**: Your actual API URL

### Option 2: Configuration File

1. Copy `Config.template.plist` to `Config.plist`
2. Replace `YOUR_API_URL_HERE` with your actual API URL
3. Modify the code to read from the plist file instead of environment variables

### Security Note

- The `.gitignore` file is configured to exclude Xcode schemes and configuration files
- Never commit sensitive URLs or API keys to version control
- Each developer should configure their own environment variables locally