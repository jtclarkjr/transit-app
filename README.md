# Transit POC

## API Configuration

This project requires an API base URL to be configured. The URL is not stored in version control for security reasons.

# Architectural Pattern

This project follows the `@Model`, `@Query`, and `@Observable` pattern using SwiftData for data management and state updates. This approach ensures a modern, reactive architecture for handling models, queries, and observable state in SwiftUI.

### Xcode Environment Variables (Recommended)

1. In Xcode, go to **Product** → **Scheme** → **Edit Scheme...**
2. Select **Run** in the left sidebar
3. Go to the **Arguments** tab
4. Under **Environment Variables**, click the **+** button
5. Add:
   - **Name**: `TRANSIT_API_BASE_URL`
   - **Value**: Your actual API URL (deployed version of /jtclarkjr/transit-api-jp repo)

### Configuration File (If not via Xcode)

1. Copy `Config.template.plist` to `Config.plist`
2. Replace `YOUR_API_URL_HERE` with your actual API URL
3. Modify the code to read from the plist file instead of environment variables

### Security Note

- The `.gitignore` file is configured to exclude Xcode schemes and configuration files
- Never commit sensitive URLs or API keys to version control
- Each developer should configure their own environment variables locally
