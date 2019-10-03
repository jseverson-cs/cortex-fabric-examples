const templates = [
    {
        $name: 'Profile',
        event: '$set',
        entityId: '$.profileId',
        entityType: '$.schemaId',
        properties: '$'
    }
];

module.exports = templates;
