# Monitoring Strategy for the ESVA Smart Septic Project

The Green Stream Technologies proposal prices a 5-home pilot at **$235,038** (~$47K/home). While their turnkey solution is well-engineered, this cost structure cannot scale to the hundreds or thousands of at-risk systems identified in the 2040 groundwater projections (~7,800 systems). This document develops an alternative strategy focused on **broad spatial coverage at minimal cost** to maximize the project's scientific and community impact.

---

## Part 1: What Do We Already Know vs. What Would Sensors Add?

Before deploying any sensors, it's worth asking: what information gaps actually exist?

### What VDH and the UVA Team Already Have

| Source | What It Provides | Limitation |
|--------|-----------------|------------|
| VDH repair records | ~90 actual failure locations/year with tax map numbers | Reactive (after failure); no data on *why* or *when* relative to weather events |
| VDH septic definitions | Regulatory framework for what constitutes failure | No spatial prediction of *where* failures will occur |
| SEAWAT groundwater model | 2040 depth-to-groundwater predictions by census block | Averaged within census blocks; "may not reflect the specific conditions of a location" (per StoryMap) |
| StoryMap risk map | 7,800 at-risk systems identified in < 3ft groundwater zones | Static prediction, no real-time monitoring; no temporal dynamics |
| Parcel-level elevation data | USGS surface elevation at high resolution | Not the same as groundwater depth, which varies with weather, season, and hydrology |

### The Actual Information Gaps

1. **Parcel-scale groundwater variability** -- The SEAWAT model averages within census blocks, but the StoryMap itself shows dramatic variation even within small towns (Nassawadox: one side of the highway is much higher than the other). Sensors could ground-truth the model at specific parcels.

2. **Temporal dynamics** -- The model gives average/predicted groundwater depth. But septic failures happen during *events* -- after a 3-day rain, during king tides, during seasonal high water tables. Nobody has continuous time-series data linking groundwater fluctuation to septic performance on the Shore.

3. **The "information to action" gap** -- Flagged by Majid in the March 2026 meeting: "early warning system --> what is the map from information to action?" VDH data tells you *after* a system fails. Sensors could tell you a system is *about to* fail -- in time to act (schedule a pump-out, avoid heavy use, alert a homeowner).

4. **Empirical link between groundwater and septic behavior** -- This is the novel science contribution. The model *predicts* groundwater depth; VDH *documents* failures. Nobody has empirically connected the two in real-time on the Shore.

### What's Highest Impact?

**Groundwater depth is the single most valuable measurement.** It is:
- The variable the SEAWAT model predicts (direct validation)
- The threshold VDH uses for risk (< 3 feet)
- The factor that changes with weather events (temporal signal)
- The most generalizable across sites (doesn't depend on knowing drainfield location)

**Soil moisture in the drainfield is secondary.** It's diagnostic for a specific household's system but less generalizable. It requires knowing exactly where the drainfield is (many homeowners don't), and it tells you about one household rather than a neighborhood.

**Rainfall data already exists.** NOAA stations, Weather Underground personal stations, and nearby airports provide precipitation data for the Shore. No need for per-site rain gauges.

**Septic tank level is deferred.** Even Green Stream deferred in-tank monitoring to future phases due to installation complexity and the corrosive environment.

---

## Part 2: Recommended Strategy -- Wide Groundwater Network + Reference Sites

### Core Principle

Deploy the **cheapest possible groundwater depth sensor** at the **maximum number of sites**, supplemented by a few fully instrumented reference stations. Trade per-site precision for spatial coverage.

### Tier 1: Reference Stations (3-5 sites) -- ~$400-500/site

Full sensor suites providing research-grade data for detailed process understanding.

| Component | Product | Est. Cost |
|-----------|---------|-----------|
| Data logger | [EnviroDIY Mayfly Starter Kit](https://www.envirodiy.org/mayfly/) | $90 |
| Groundwater sensor | Submersible pressure transducer (generic 4-20mA, 5m range) | $30-60 |
| Soil moisture sensor | Capacitive probe (Vegetronix VH400 or generic) | $40-60 |
| Piezometer well | 2-3" PVC pipe, screen, sand pack (DIY install) | $20-40 |
| Communication | LTE-M cellular module (Digi XBee3) | $50-80 |
| Power | Solar panel (6W) + LiPo battery | $30-50 |
| Enclosure | Weatherproof box (IP67) | $20-30 |
| **Total per site** | | **$280-410** |

**Purpose:** Detailed process understanding -- how do groundwater fluctuations, soil saturation, and weather events interact at a specific septic system? Generates publishable data and calibrates the relationship between groundwater depth and drainfield performance.

**Platform:** [EnviroDIY Mayfly](https://www.envirodiy.org/mayfly/) ($60-90 board) -- open-source, Arduino-compatible, designed for environmental monitoring. Free cloud dashboard via [Monitor My Watershed](https://monitormywatershed.org/). [Construction guide for groundwater stations](https://www.envirodiy.org/construction-of-water-level-monitoring-sensor-station/) available. Proven in Trout Unlimited and other real-world deployments.

**Alternative:** Use Green Stream for 2-3 of these reference sites if the project wants bulletproof, contractor-managed stations with guaranteed uptime. Negotiate a reduced scope (~$50-80K for 2-3 sites instead of $235K for 5).

### Tier 2: Distributed Groundwater Network (30-50 sites) -- ~$100-150/site

The backbone of the strategy. Groundwater depth only, maximum spatial coverage.

| Component | Product | Est. Cost |
|-----------|---------|-----------|
| Groundwater sensor | [Generic submersible pressure transducer](https://www.amazon.com/Submersible-Piezometers-Pressure-Transmitter-Sensor/dp/B0DGCM9R9B) (4-20mA or 0-5V, 5m range) | $30-50 |
| Microcontroller + radio | Heltec WiFi LoRa 32 (ESP32 + LoRa on one board) | $20-25 |
| Piezometer | 2" PVC pipe, 3-5ft deep, screened at bottom, sand pack | $20-40 |
| Power | Small solar panel (2-3W) + 18650 LiPo battery | $15-25 |
| Enclosure | Basic weatherproof junction box | $10-15 |
| **Total per site** | | **$95-155** |

**What this measures:** Daily (or more frequent) groundwater depth readings -- specifically, how often and how long the water table sits above the 3-foot threshold at each parcel.

**Why this is enough:** The critical question for most of the Shore is essentially binary: *is groundwater above or below ~3 feet?* A $30 pressure transducer in a shallow PVC piezometer answers that question. You don't need millimeter precision or multi-parameter sensing to validate the SEAWAT model or identify at-risk parcels.

**Student role:** ESCC students assemble the sensor nodes (soldering, programming, waterproofing) as part of the Field Monitoring Technician Program, then assist with installation and periodic maintenance visits.

### Tier 3: Community Self-Reporting (unlimited sites) -- $0/site

Broadest participation, qualitative data, community ownership.

- **Weather-to-Flush-Failure Diary Study:** Households keep simple logs correlating rain events with septic symptoms (backup, odor, standing water, can't flush)
- **Collection method:** Paper forms at community events, or a simple Google Form / text-message reporting system
- **Purpose:** Qualitative dataset covering far more households than any sensor network; validates whether sensor-detected groundwater events correspond to actual septic problems experienced by residents; builds community engagement and awareness

### Shared Infrastructure (one-time)

| Component | Est. Cost | Notes |
|-----------|-----------|-------|
| LoRaWAN gateway (outdoor) | $300 | One covers 10-15 km radius -- likely the entire study area on the flat Shore |
| Second gateway (redundancy/coverage) | $300 | Optional; extends coverage or provides backup |
| Network server | Free | [The Things Network](https://www.thethingsnetwork.org/) community edition |
| Dashboard | Free | Open-source: Grafana + InfluxDB, or Node-RED |
| Rainfall data | Free | NOAA stations, Weather Underground, nearby airport data |

**LoRaWAN advantage for the Shore:** LoRa signals travel 10-15 km over flat rural terrain using unlicensed spectrum -- no per-device cellular fees. The Eastern Shore's flat, open geography is ideal. One or two gateways mounted on a tall structure (ESCC building, water tower, church steeple) could cover the entire study area.

### Total Budget Estimate

| Tier | Sites | Per-Site | Subtotal |
|------|-------|----------|----------|
| Tier 1 (reference stations) | 5 | $400 | $2,000 |
| Tier 2 (groundwater network) | 40 | $125 | $5,000 |
| Tier 3 (self-report) | 50+ | $0 | $0 |
| LoRaWAN gateways | -- | -- | $600 |
| Assembly/calibration labor (student hours) | -- | -- | ~$2,000 |
| Contingency (spare parts, failed units, misc.) | -- | -- | ~$1,500 |
| **Total** | **95+** | -- | **~$11,100** |

**95+ monitoring points for ~$11,100** vs. Green Stream's $235,000 for 5 sites.

---

## Part 3: Site Selection Strategy

Site selection is where the scientific value is made or lost. The network should be designed to answer specific questions, not just scatter sensors randomly.

### Selection Criteria

Sites should be chosen to **sample across key variables** that the SEAWAT model predicts and that the project needs to validate:

#### A. Stratify by Model-Predicted Risk Zone

The StoryMap's 2040 prediction map divides the Shore into groundwater depth zones. Deploy sensors across all zones to test whether the model's predictions match reality.

| Risk Zone | Predicted Groundwater Depth | Target # of Sites | Purpose |
|-----------|---------------------------|-------------------|---------|
| Highest risk | < 3 ft (model predicts chronic failure zone) | 15-20 | Confirm the model; track how often threshold is exceeded |
| Moderate risk | 3-5 ft (model predicts episodic risk) | 10-15 | Detect whether rain events push these sites into failure range |
| Lower risk | > 5 ft (model predicts safe) | 5-10 | Control group; confirm these sites stay safe; detect model errors |

#### B. Stratify by Geographic Factors

The Shore's hydrology varies by location. Ensure the network captures this diversity:

| Factor | Why It Matters | How to Sample |
|--------|---------------|---------------|
| **Bayside vs. seaside** | Different tidal influence, drainage patterns, soil types | Split sites roughly evenly between Chesapeake Bay side and Atlantic/barrier island side |
| **Proximity to ditches/streams** | Ditches lower local water table; proximity matters (Parksley example) | Include sites near and far from drainage ditches |
| **Elevation micro-variation** | Nassawadox: one side of the highway is dramatically different | Include paired sites at different elevations within the same town |
| **North-south gradient** | Accomack County (north) vs. Northampton County (south) may differ | Distribute across both counties |

#### C. Overlay with VDH Repair Data

VDH's ~90 repairs/year with tax map numbers are a goldmine for site selection:

- **Deploy sensors near recent repair locations** -- Do these parcels show chronically high groundwater, or was the failure from another cause (age, misuse)?
- **Deploy sensors in model-predicted high-risk areas with NO repair history** -- Are these genuinely safe, or are failures going unreported?
- **Compare** -- If high-groundwater parcels don't correlate with repair history, that tells you something important about whether groundwater is actually the primary driver vs. age/use.

#### D. Community and Practical Factors

| Factor | Consideration |
|--------|--------------|
| **Homeowner willingness** | Must have resident consent; leverage existing CoPe community relationships |
| **Physical access** | Need to install a 3-5ft PVC piezometer and a small solar-powered sensor box in the yard |
| **Known drainfield location** (for Tier 1 only) | Reference stations need soil moisture probes near the drainfield; homeowner or VDH records may help locate it |
| **Representation** | Include a range of housing types, lot sizes, and income levels to address equity dimensions |

### Priority Towns for Deployment

Based on the StoryMap, meeting notes, and community engagement history:

| Town | Why | Suggested Role |
|------|-----|----------------|
| **Parksley** | StoryMap example; lot-to-lot variation within town; established community relationships | Dense cluster of sensors to test micro-scale variation |
| **Exmore** | StoryMap flags as likely needing more alternative systems; larger town | Mix of risk zones; good for community engagement events |
| **Nassawadox** | High water table; dramatic elevation split across highway | Paired sensors on each side of the highway to quantify difference |
| **Onancock / Accomac** | County seat area; mix of development patterns | Geographic diversity (northern Shore) |
| **Cape Charles / Cheriton** | Southern tip; different hydrology; tourism/development pressure | Northampton County representation |
| **Rural parcels between towns** | Agricultural areas with septics and no municipal services | Captures the most vulnerable, isolated households |

### Proposed Site Allocation (40 Tier 2 sites)

| Location | # Sites | Rationale |
|----------|---------|-----------|
| Parksley cluster | 6-8 | Dense deployment testing micro-scale model accuracy |
| Exmore / Nassawadox | 6-8 | High-risk zones with engagement potential |
| Onancock / Accomac area | 5-6 | Northern Shore, bayside representation |
| Cape Charles / Cheriton area | 5-6 | Southern Shore, different hydrology |
| Rural / dispersed parcels | 10-15 | Geographic fill; near VDH repair sites; equity representation |

The 5 Tier 1 reference stations should be placed in **Parksley** (1-2, where dense Tier 2 coverage allows cross-validation), **Nassawadox** (1, high water table), **Exmore** (1, predicted high risk), and one **rural parcel near a known VDH repair** (1, to study the failure mechanism in detail).

---

## Part 4: Comparison with Green Stream Proposal

Green Stream's value is real -- they offer professional engineering, guaranteed uptime, a polished cloud platform, and field support. Their solution makes sense if you need a **small, bulletproof, hands-off deployment**.

But the project's goals (model validation, community engagement, scalable monitoring) may be better served by a larger, lower-cost network that trades polish for spatial coverage.

| Factor | Green Stream | Wide Groundwater Network |
|--------|-------------|--------------------------|
| Sites covered | 5 | 95+ |
| Total cost | $235,000 | ~$11,100 |
| Primary measurement | Multi-parameter | Groundwater depth (+ full suite at 5 reference sites) |
| Data quality | Professional-grade | Adequate for threshold detection and model validation |
| Maintenance | Contractor-managed | Student/community-managed |
| Student involvement | Limited | Central (assembly, installation, maintenance) |
| Community engagement | Low (contractor installs) | High (residents participate, see their own data) |
| Scalability | Expensive to expand | Cheap to add sites |
| Risk | Low (proven vendor) | Higher (DIY reliability, but mitigated by redundancy) |
| Scientific output | Detailed process data at few points | Spatial coverage for model validation + process data at reference sites |
| Model validation power | 5 data points | 40+ data points across risk zones |

**Middle path:** Use Green Stream for 2-3 reference sites where bulletproof data is essential (~$50-80K negotiated), and deploy the DIY groundwater network for spatial coverage (~$8-11K). Total: ~$60-90K, well under the original $235K, with far more scientific and community value.

---

## Part 5: Hardware Options Reference

Preserved here for reference when selecting specific components.

### Data Loggers & Microcontrollers

| Product | Cost | Communication | Power | Best For |
|---------|------|---------------|-------|----------|
| [EnviroDIY Mayfly](https://www.envirodiy.org/mayfly/) | $60-90 | Cellular (XBee), SDI-12, analog | Solar + LiPo | Tier 1 reference stations |
| Heltec WiFi LoRa 32 (ESP32 + LoRa) | $20-25 | LoRa (built-in), WiFi | Solar + 18650 | Tier 2 distributed network |
| [Makerfabs LoRa Soil Moisture V3](https://www.makerfabs.com/lora-soil-moisture-sensor-v3.html) | ~$20 | LoRa | 2x AAA (2+ year life) | Ultra-low-cost soil moisture nodes |

### Groundwater Depth Sensors

| Product | Cost | Output | Notes |
|---------|------|--------|-------|
| [Generic submersible pressure transducer (Amazon)](https://www.amazon.com/Submersible-Piezometers-Pressure-Transmitter-Sensor/dp/B0DGCM9R9B) | $30-60 | 4-20mA or 0-5V | Stainless steel, vented cable, adequate for 3-ft threshold detection |
| Calibrated research-grade transducer | $100-300 | SDI-12 or analog | For Tier 1 reference stations if higher accuracy needed |
| [PDX Scholar open-source ultrasonic piezometer sensor](https://pdxscholar.library.pdx.edu/studentsymposium/2014/Poster/5/) | DIY | Analog | Sub-centimeter resolution, Arduino-based |

### Soil Moisture Sensors (Tier 1 only)

| Product | Cost | Interface | Notes |
|---------|------|-----------|-------|
| Vegetronix VH400 | $40-50 | Analog | Used in Green Stream proposal; proven for drainfield monitoring |
| [Milesight EM500-SMTC](https://www.milesight.com/iot/product/lorawan-sensor/em500-smtc) | $150-250 | LoRaWAN | All-in-one: moisture + temp + conductivity, IP67, 10yr battery |
| [Sensoterra LoRaWAN probe](https://www.sensoterra.com/) | ~$100-200 | LoRaWAN | 6-8 year battery, built-in connectivity |
| Generic capacitive probe | $5-15 | Analog | Cheapest option but needs waterproofing for permanent outdoor use |

### Network Infrastructure

| Component | Product | Cost | Notes |
|-----------|---------|------|-------|
| LoRaWAN gateway (indoor) | RAK7268 | ~$150 | Good for testing; shorter range |
| LoRaWAN gateway (outdoor) | RAK7289 or similar | ~$300 | Weatherproof; mount on tall structure for max range |
| Network server | [The Things Network](https://www.thethingsnetwork.org/) | Free | Community edition; handles routing from gateway to application |
| Dashboard | Grafana + InfluxDB | Free | Open-source; self-hosted or free tier cloud |
| Cloud data | [Monitor My Watershed](https://monitormywatershed.org/) | Free | EnviroDIY's platform; best for Tier 1 Mayfly stations |

---

## Sources & Further Reading

- [EnviroDIY Mayfly Data Logger](https://www.envirodiy.org/mayfly/) -- $60-90, open-source environmental data logger
- [EnviroDIY Groundwater Monitoring Station Guide](https://www.envirodiy.org/construction-of-water-level-monitoring-sensor-station/) -- step-by-step build guide
- [Milesight EM500-SMTC LoRaWAN Soil Sensor](https://www.milesight.com/iot/product/lorawan-sensor/em500-smtc)
- [Makerfabs LoRa Soil Moisture Sensor V3](https://www.makerfabs.com/lora-soil-moisture-sensor-v3.html) -- 2+ year battery, corrosion-resistant
- [The Things Network](https://www.thethingsnetwork.org/) -- free community LoRaWAN network server
- [PDX Scholar: Open-Source Low-Cost Piezometer Sensor](https://pdxscholar.library.pdx.edu/studentsymposium/2014/Poster/5/) -- Arduino-based, sub-cm resolution
- [Sensoterra LoRaWAN Soil Moisture Sensors](https://www.sensoterra.com/) -- 6-8 year battery life
- [Amazon: Generic Submersible Pressure Transducers](https://www.amazon.com/Submersible-Piezometers-Pressure-Transmitter-Sensor/dp/B0DGCM9R9B) -- $30-60 range
