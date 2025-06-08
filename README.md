# Tokenized Religious Pilgrimage Management System

A comprehensive blockchain-based system for managing religious pilgrimages using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized platform for organizing, coordinating, and managing religious pilgrimages while preserving cultural significance and ensuring participant safety.

## Features

### 🏛️ Core Contracts

1. **Organizer Verification Contract** (`organizer-verification.clar`)
    - Validates pilgrimage organizers
    - Manages reputation scores
    - Handles verification requests
    - Tracks organizer performance

2. **Journey Coordination Contract** (`journey-coordination.clar`)
    - Creates and manages pilgrimage journeys
    - Handles participant registration
    - Manages journey capacity and pricing
    - Tracks journey status

3. **Accommodation Management Contract** (`accommodation-management.clar`)
    - Registers accommodation providers
    - Manages room bookings
    - Handles availability and pricing
    - Verifies accommodation quality

4. **Safety Monitoring Contract** (`safety-monitoring.clar`)
    - Reports and tracks safety incidents
    - Manages emergency contacts
    - Creates safety checkpoints
    - Monitors participant welfare

5. **Cultural Preservation Contract** (`cultural-preservation.clar`)
    - Registers cultural sites
    - Documents traditional practices
    - Manages preservation contributions
    - Protects cultural heritage

## Getting Started

### Prerequisites

- Stacks blockchain node
- Clarity CLI tools
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd pilgrimage-management
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Deploy contracts to Stacks blockchain:
   \`\`\`bash
# Deploy each contract individually
clarinet deploy contracts/organizer-verification.clar
clarinet deploy contracts/journey-coordination.clar
clarinet deploy contracts/accommodation-management.clar
clarinet deploy contracts/safety-monitoring.clar
clarinet deploy contracts/cultural-preservation.clar
\`\`\`

### Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Individual test files:
\`\`\`bash
npm test organizer-verification.test.js
npm test journey-coordination.test.js
npm test accommodation-management.test.js
npm test safety-monitoring.test.js
npm test cultural-preservation.test.js
\`\`\`

## Usage Examples

### Registering as an Organizer

\`\`\`clarity
(contract-call? .organizer-verification register-organizer)
\`\`\`

### Creating a Pilgrimage Journey

\`\`\`clarity
(contract-call? .journey-coordination create-journey
"Sacred Mountain Pilgrimage"
u1000
u1007
u50
u1000)
\`\`\`

### Booking Accommodation

\`\`\`clarity
(contract-call? .accommodation-management book-accommodation
u1
u1000
u1003
u2)
\`\`\`

### Reporting Safety Incident

\`\`\`clarity
(contract-call? .safety-monitoring report-incident
u1
"Medical"
"Minor injury at checkpoint"
"Trail Marker 5"
"medium")
\`\`\`

### Registering Cultural Site

\`\`\`clarity
(contract-call? .cultural-preservation register-cultural-site
"Ancient Temple"
"Sacred Valley"
"Historical significance description"
"Visitor guidelines")
\`\`\`

## Contract Architecture

### Data Flow

1. **Organizer Registration** → Verification → Journey Creation
2. **Journey Creation** → Participant Registration → Accommodation Booking
3. **Safety Monitoring** → Incident Reporting → Emergency Response
4. **Cultural Sites** → Practice Documentation → Preservation Contributions

### Security Features

- Principal-based access control
- Input validation and sanitization
- Error handling with descriptive codes
- State consistency checks
- Immutable audit trails

## API Reference

### Organizer Verification

- `register-organizer()` - Register as a pilgrimage organizer
- `submit-verification-request()` - Submit verification request
- `verify-organizer(principal)` - Verify an organizer (admin only)
- `get-organizer-info(principal)` - Get organizer information
- `is-verified-organizer(principal)` - Check verification status

### Journey Coordination

- `create-journey(...)` - Create new pilgrimage journey
- `register-for-journey(uint, string)` - Register for a journey
- `update-journey-status(uint, string)` - Update journey status
- `get-journey-info(uint)` - Get journey details
- `get-available-spots(uint)` - Check available spots

### Accommodation Management

- `register-accommodation(...)` - Register accommodation
- `book-accommodation(...)` - Book accommodation
- `verify-accommodation(uint)` - Verify accommodation quality
- `get-accommodation-info(uint)` - Get accommodation details
- `check-availability(uint, uint)` - Check room availability

### Safety Monitoring

- `report-incident(...)` - Report safety incident
- `set-emergency-contacts(...)` - Set emergency contacts
- `create-safety-checkpoint(...)` - Create safety checkpoint
- `get-safety-report(uint)` - Get incident report
- `get-emergency-contacts(uint)` - Get emergency contacts

### Cultural Preservation

- `register-cultural-site(...)` - Register cultural site
- `document-cultural-practice(...)` - Document cultural practice
- `contribute-to-preservation(...)` - Make preservation contribution
- `get-cultural-site(uint)` - Get site information
- `get-cultural-practice(uint)` - Get practice details

## Error Codes

- `u100-u103` - Organizer Verification errors
- `u200-u204` - Journey Coordination errors
- `u300-u303` - Accommodation Management errors
- `u400-u402` - Safety Monitoring errors
- `u500-u502` - Cultural Preservation errors

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## Roadmap

- [ ] Mobile application integration
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Integration with payment systems
- [ ] Enhanced cultural preservation tools
- [ ] Community governance features
