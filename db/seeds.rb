# Seeds are idempotent — safe to re-run at any time.
# Uses find_or_initialize_by so re-running updates all fields.
#
# Usage:
#   USER_EMAIL="isara@example.com" USER_PASSWORD="securepassword" USER_NAME="Dr Isara Khanjanasthiti" rails db:seed

puts ""
puts "━" * 50
puts "  🌱 Seeding isarak-portfolio database"
puts "━" * 50
puts ""

# ===== USER =====
puts "── User ──────────────────────────────────────────"
email    = ENV.fetch("USER_EMAIL", "admin@example.com")
password = ENV.fetch("USER_PASSWORD", "password123!")
name     = ENV.fetch("USER_NAME", "Dr Isara Khanjanasthiti")

user = User.find_or_initialize_by(email: email)
user.assign_attributes(password: password, password_confirmation: password, name: name)
user.save!
puts "  ✓ User: #{email}"
puts ""

# ===== TEACHINGS =====
# 6 seeds, 3 featured (featured items appear in the homepage Teaching spotlight)
puts "── Teachings ─────────────────────────────────────"

teachings_data = [
  {
    title: "PLAN301 — Urban and Regional Planning Studio",
    institution: "University of New England",
    year: 2024,
    featured: true,
    image_url: "https://picsum.photos/seed/plan301/800/600",
    description: "A capstone studio unit for third-year planning students. Students work in multidisciplinary teams to develop a planning proposal for a real site, engaging community stakeholders, local councils, and industry mentors. Assessment includes oral presentations, stakeholder consultation reports, and a final planning proposal."
  },
  {
    title: "PLAN201 — Introduction to Land Use Planning",
    institution: "University of New England",
    year: 2024,
    featured: true,
    image_url: "https://picsum.photos/seed/plan201/800/600",
    description: "A core second-year unit introducing the theory and practice of land use planning in Australia. Topics include the NSW planning system, environmental impact assessment, development control plans, strategic planning frameworks, and community participation."
  },
  {
    title: "PLAN401 — Advanced Planning Theory and Policy",
    institution: "University of New England",
    year: 2023,
    featured: true,
    image_url: "https://picsum.photos/seed/plan401/800/600",
    description: "A postgraduate unit examining contemporary debates in planning theory, including communicative planning, informality, smart cities, climate adaptation, and decolonising planning practice. Students produce original research essays engaging critically with planning literature."
  },
  {
    title: "PLAN102 — Introduction to Urban Geography",
    institution: "University of New England",
    year: 2023,
    featured: false,
    image_url: "https://picsum.photos/seed/plan102/800/600",
    description: "An introductory unit exploring the spatial dimensions of urban life — how cities grow, how they are shaped by infrastructure and migration, and how inequality is expressed geographically. Includes case studies from Australia, Southeast Asia, and Europe."
  },
  {
    title: "PLAN220 — Environmental Planning and Assessment",
    institution: "University of New England",
    year: 2024,
    featured: false,
    image_url: "https://picsum.photos/seed/plan220/800/600",
    description: "Covers the environmental assessment frameworks used in Australian planning systems, including EIS preparation, biodiversity offsetting, heritage impact statements, and climate risk disclosure. Students complete a practitioner-style environmental assessment for a hypothetical development."
  },
  {
    title: "PLAN320 — Housing Policy and Planning",
    institution: "University of New England",
    year: 2023,
    featured: false,
    image_url: "https://picsum.photos/seed/plan320/800/600",
    description: "Examines housing policy across the supply, affordability, and social housing dimensions of the Australian housing system. Topics include zoning reform, inclusionary zoning, build-to-rent, and comparative international housing systems."
  }
]

teachings_data.each do |attrs|
  record = Teaching.find_or_initialize_by(title: attrs[:title], user: user)
  record.assign_attributes(attrs.except(:title))
  record.save!
  puts "  ✓ #{attrs[:title]}"
end
puts "  → #{teachings_data.length} teachings seeded (#{teachings_data.count { |t| t[:featured] }} featured)"
puts ""

# ===== RESEARCH ITEMS =====
# 8 seeds, 4 featured (featured items appear in the homepage Research grid)
puts "── Research Items ────────────────────────────────"

research_data = [
  {
    title: "Cross-Border Regional Planning and Airport-Driven Urban Development: The Gold Coast Case",
    category: :publication,
    featured: true,
    image_url: "https://picsum.photos/seed/research-airport/800/600",
    external_url: "https://www.une.edu.au",
    published_at: Date.new(2022, 11, 1),
    description: "This doctoral thesis examines the governance and planning challenges arising from Gold Coast Airport's position on the Queensland–NSW border. It develops a framework for cross-border planning coordination in airport regions."
  },
  {
    title: "Airport City Development and Second-Tier Aviation Markets: Evidence from Australia and Southeast Asia",
    category: :project,
    featured: true,
    image_url: "https://picsum.photos/seed/research-city/800/600",
    external_url: nil,
    published_at: Date.new(2024, 7, 1),
    description: "An ongoing project investigating economic and planning impacts of airport city strategies at secondary airports. Combines spatial analysis with qualitative case studies of Gold Coast, Avalon, Suvarnabhumi, and KLIA."
  },
  {
    title: "Housing Affordability and Zoning Reform: A Comparative Analysis of Australian Capital Cities",
    category: :paper,
    featured: true,
    image_url: "https://picsum.photos/seed/research-housing/800/600",
    external_url: "https://www.une.edu.au",
    published_at: Date.new(2023, 4, 15),
    description: "Examines the relationship between zoning restrictiveness and housing supply elasticity across Sydney, Melbourne, and Brisbane. Finds that infill development constraints are the primary driver of affordability deterioration in inner suburbs."
  },
  {
    title: "Transit-Oriented Development Outcomes in Southeast Asian Cities: Implications for Australian Planning",
    category: :paper,
    featured: true,
    image_url: "https://picsum.photos/seed/research-tod/800/600",
    external_url: "https://www.une.edu.au",
    published_at: Date.new(2024, 2, 28),
    description: "A comparative study of TOD implementation in Bangkok, Singapore, and Kuala Lumpur, drawing governance and financing lessons for Australian station-area planning."
  },
  {
    title: "Intergovernmental Coordination Failures in Airport-Adjacent Development: A Policy Analysis",
    category: :paper,
    featured: false,
    image_url: "https://picsum.photos/seed/research-gov/800/600",
    external_url: "https://www.une.edu.au",
    published_at: Date.new(2023, 9, 1),
    description: "Analyses documented cases of intergovernmental coordination failure in airport-adjacent development decisions across Queensland, NSW, and Victoria, proposing a tiered joint planning agreement model."
  },
  {
    title: "Informal Settlements and Planning Theory: Towards a More Inclusive Framework",
    category: :paper,
    featured: false,
    image_url: "https://picsum.photos/seed/research-informal/800/600",
    external_url: nil,
    published_at: Date.new(2023, 6, 30),
    description: "Argues that informal settlements are better understood as adaptive responses to housing market exclusion rather than planning failures, and proposes a revised theoretical framework for planning practice."
  },
  {
    title: "The Role of Low-Cost Carriers in Secondary Airport Growth: A Spatial Analysis",
    category: :project,
    featured: false,
    image_url: "https://picsum.photos/seed/research-lcc/800/600",
    external_url: nil,
    published_at: Date.new(2024, 5, 15),
    description: "A GIS-based analysis of low-cost carrier route networks and their spatial relationship to population density, employment centres, and housing growth corridors around secondary Australian airports."
  },
  {
    title: "Planning Education Reform: Authentic Assessment in Professional Degree Programs",
    category: :publication,
    featured: false,
    image_url: "https://picsum.photos/seed/research-edu/800/600",
    external_url: "https://www.une.edu.au",
    published_at: Date.new(2022, 8, 1),
    description: "Examines the gap between assessment formats in Australian planning education and the communication skills demanded of practitioners, proposing an authentic assessment framework trialled at UNE."
  }
]

research_data.each do |attrs|
  record = ResearchItem.find_or_initialize_by(title: attrs[:title], user: user)
  record.assign_attributes(attrs.except(:title))
  record.save!
  puts "  ✓ #{attrs[:title][0..65]}..."
end
puts "  → #{research_data.length} research items seeded (#{research_data.count { |r| r[:featured] }} featured)"
puts ""

# ===== GRANTS & AWARDS =====
# 8 seeds, 6 featured (featured items all appear on the homepage Awards slider — no limit)
puts "── Grants & Awards ───────────────────────────────"

grants_data = [
  {
    title: "Australian Research Council Discovery Early Career Researcher Award (DECRA)",
    category: :grant,
    featured: true,
    awarding_body: "Australian Research Council",
    year: 2023,
    description: "A three-year DECRA fellowship supporting research into cross-border governance frameworks for airport-adjacent urban development. The project develops a practical policy toolkit for state and local governments managing multi-jurisdictional airport regions."
  },
  {
    title: "UNE Strategic Research Support Scheme — Airport Governance Project",
    category: :grant,
    featured: true,
    awarding_body: "University of New England",
    year: 2024,
    description: "Seed funding supporting the initiation of the Airport City Development comparative research project, including fieldwork travel to Southeast Asia and engagement with international airport planning authorities."
  },
  {
    title: "Planning Institute of Australia Research Fellowship",
    category: :grant,
    featured: true,
    awarding_body: "Planning Institute of Australia",
    year: 2022,
    description: "A competitive fellowship awarded to support policy-relevant research that advances planning practice. Supported completion of the cross-border planning governance analysis with direct engagement with PIA member practitioners."
  },
  {
    title: "UNE Vice-Chancellor's Award for Excellence in Teaching",
    category: :award,
    featured: true,
    awarding_body: "University of New England",
    year: 2023,
    description: "Awarded in recognition of outstanding contributions to student learning and innovative curriculum design in the urban planning program. Cited for the introduction of authentic assessment formats that better reflect professional planning practice."
  },
  {
    title: "Planning Institute of Australia NSW Young Planner Award",
    category: :award,
    featured: true,
    awarding_body: "Planning Institute of Australia (NSW Chapter)",
    year: 2021,
    description: "Awarded to a planning professional or academic under 35 who has demonstrated exceptional promise and contribution to the planning profession in NSW. Recognised for research impact and engagement with planning policy reform."
  },
  {
    title: "State of Australian Cities Conference — Best Paper Award",
    category: :award,
    featured: true,
    awarding_body: "Australian Cities Research Network",
    year: 2022,
    description: "Best paper award at the State of Australian Cities Conference for the paper on intergovernmental coordination failures in airport-adjacent development, selected by the peer review committee from 240 submitted papers."
  },
  {
    title: "UNE HDR Completion Scholarship",
    category: :grant,
    featured: false,
    awarding_body: "University of New England",
    year: 2022,
    description: "Competitive scholarship awarded to Higher Degree Research candidates in the final stage of doctoral completion to support full-time thesis write-up."
  },
  {
    title: "Planning Institute of Australia National Congress — Commendation",
    category: :award,
    featured: false,
    awarding_body: "Planning Institute of Australia",
    year: 2023,
    description: "Commendation at the national PIA Congress awards for contributions to planning education, recognising innovative curriculum development and student outcomes in the UNE planning program."
  }
]

grants_data.each do |attrs|
  record = GrantAward.find_or_initialize_by(title: attrs[:title], user: user)
  record.assign_attributes(attrs.except(:title))
  record.save!
  puts "  ✓ [#{attrs[:category]}] #{attrs[:title][0..60]}..."
end
puts "  → #{grants_data.length} grants/awards seeded (#{grants_data.count { |g| g[:featured] }} featured)"
puts ""

# ===== BLOG POSTS =====
# 6 seeds, 3 featured published (featured published posts appear on the homepage Blog section)
puts "── Blog Posts ────────────────────────────────────"

blog_posts_data = [
  {
    title: "Cross-Border Planning Around Gold Coast Airport: Lessons for Regional Governance",
    blog_excerpt: "Airport-driven development rarely respects administrative boundaries — my doctoral research explores how Gold Coast Airport has reshaped regional planning across the Queensland–NSW border.",
    status: :published,
    featured: true,
    ai_generated: false,
    image_url: "https://picsum.photos/seed/blog-airport/800/450",
    created_at: 3.months.ago,
    body_html: "<h2>The Challenge of Jurisdictional Overlap</h2><p>Aviation infrastructure does not conform to state borders, yet planning policy in Australia remains stubbornly jurisdictional. My doctoral research examined how Gold Coast Airport — straddling the Queensland–New South Wales boundary — has created a complex governance landscape that neither state is fully equipped to manage alone.</p><h2>Key Findings</h2><p>The case study revealed three recurring tensions: economic competition between councils, inconsistent land-use zoning on either side of the border, and a near-total absence of formal intergovernmental coordination mechanisms.</p><h2>Implications for Australian Planning</h2><p>If Australia is serious about unlocking the economic potential of secondary airports, we need cross-border governance frameworks that match the spatial reality of airport-driven growth.</p>"
  },
  {
    title: "Housing Affordability in Sydney: Why Urban Planners Must Lead the Conversation",
    blog_excerpt: "Sydney's housing crisis is as much a planning failure as it is a market failure. Urban planners have both the tools and the professional obligation to drive meaningful reform.",
    status: :published,
    featured: true,
    ai_generated: false,
    image_url: "https://picsum.photos/seed/blog-housing/800/450",
    created_at: 2.months.ago,
    body_html: "<h2>A Crisis Hiding in Plain Sight</h2><p>Sydney's median house price-to-income ratio now sits above 13 — a figure that would have seemed absurd to planners in the 1980s. Yet housing affordability is still treated as primarily a market problem, with planning cast in a supporting role at best.</p><h2>The Planning Dimension</h2><p>Zoning restrictions, heritage overlays, development contribution frameworks, and slow assessment timelines all act as supply-side constraints that compound affordability pressures. These are planning failures, and they require planning solutions.</p><h2>What Needs to Change</h2><p>Evidence from international comparisons — particularly Tokyo's liberalised zoning and Vienna's social housing model — suggests that planning systems can and do shape housing outcomes at scale.</p>"
  },
  {
    title: "Rethinking Assessment in Urban Planning Education: Moving Beyond the Final Report",
    blog_excerpt: "Traditional planning studios culminate in thick reports that few practitioners ever read. I've been experimenting with assessment formats that better reflect how planners actually communicate in practice.",
    status: :published,
    featured: true,
    ai_generated: false,
    image_url: "https://picsum.photos/seed/blog-education/800/450",
    created_at: 6.weeks.ago,
    body_html: "<h2>The Problem with the 5,000-Word Report</h2><p>Ask any practising urban planner how often they submit a 5,000-word written report in their day-to-day work. The answer, almost universally, is: never. Yet this remains the dominant assessment format in Australian planning schools.</p><h2>What Practitioners Actually Do</h2><p>Planners present to councils, brief ministers, facilitate community engagement workshops, and prepare development assessment reports — none of which map neatly onto a traditional academic essay.</p><h2>Alternatives Worth Trialling</h2><p>In my recent studio units I have experimented with oral examinations, policy briefing notes, community consultation simulations, and peer-assessed design charrettes. The results have been encouraging: students engage more deeply when the output format feels professionally authentic.</p>"
  },
  {
    title: "Second-Tier Airports and Regional Economic Development: A Literature Review",
    blog_excerpt: "What does the research actually say about whether airports generate the economic growth governments promise? The picture is more nuanced than most airport proponents admit.",
    status: :published,
    featured: false,
    ai_generated: false,
    image_url: "https://picsum.photos/seed/blog-aviation/800/450",
    created_at: 2.weeks.ago,
    body_html: "<h2>The Aviation-Growth Thesis</h2><p>Airports are frequently positioned as engines of regional economic development — catalysts for tourism, logistics, and business investment. This narrative is politically compelling, but the empirical evidence is considerably more mixed.</p><h2>What the Literature Finds</h2><p>Meta-analyses consistently show that projections made by airport proponents overstate induced employment and business activity, often by a factor of two or three.</p><h2>The Second-Tier Case</h2><p>Secondary airports face a particularly challenging evidence base. While some, like Gold Coast and Avalon, have demonstrated genuine catalytic effects in specific niches, the conditions enabling these outcomes are not easily replicated.</p>"
  },
  {
    title: "What Bangkok Can Teach Sydney About Transit-Oriented Development",
    blog_excerpt: "Bangkok's BTS Skytrain corridor has produced some of Southeast Asia's most striking examples of transit-oriented development. There are lessons — and cautionary tales — for Australian cities.",
    status: :published,
    featured: false,
    ai_generated: true,
    image_url: "https://picsum.photos/seed/blog-bangkok/800/450",
    created_at: 1.month.ago,
    body_html: "<h2>Bangkok's TOD Transformation</h2><p>When the BTS Skytrain opened in 1999, Bangkok was widely regarded as a cautionary tale of urban sprawl. Two decades later, the corridors around Asok, Phrom Phong, and On Nut tell a different story: dense, walkable, mixed-use precincts that have fundamentally reshaped how middle-class Bangkokians live and move.</p><h2>Why It Worked</h2><p>Several factors converged: concentrated land ownership patterns, private-sector incentives to drive ridership through station-area development, and municipal planning flexible enough to permit density uplifts quickly.</p><h2>What Sydney Can Take From This</h2><p>Australian TOD aspirations are frequently frustrated by land fragmentation, slow rezonings, and infrastructure contribution regimes that make high-density development near stations financially marginal.</p>"
  },
  {
    title: "The Role of Informal Settlements in Urban Planning Theory",
    blog_excerpt: "Informal settlements are often treated as planning failures to be managed or eradicated. I argue they are better understood as adaptive responses to housing market exclusion.",
    status: :draft,
    featured: false,
    ai_generated: true,
    image_url: "https://picsum.photos/seed/blog-informal/800/450",
    created_at: 4.days.ago,
    body_html: "<h2>Framing the Problem</h2><p>Mainstream urban planning theory has long struggled with informality. The dominant framing treats informal settlements as deviations from a planned norm: problems to be solved through slum clearance, forced relocation, or progressive upgrading.</p><h2>An Alternative Lens</h2><p>A growing body of scholarship argues that informality is better understood as a mode of urbanisation — not an exception to the rule, but a constitutive feature of how cities grow under rapid urbanisation and housing market exclusion.</p><h2>Implications for Practice</h2><p>Rather than managing informality out of existence, planners should ask how formal systems can adapt to recognise and build upon the self-help housing strategies that millions of urban residents already employ.</p>"
  }
]

blog_posts_data.each do |attrs|
  record = BlogPost.find_or_initialize_by(title: attrs[:title], user: user)
  record.assign_attributes(
    blog_excerpt: attrs[:blog_excerpt],
    status: attrs[:status],
    featured: attrs[:featured],
    ai_generated: attrs[:ai_generated],
    image_url: attrs[:image_url],
    created_at: attrs[:created_at]
  )

  if attrs[:ai_generated]
    record.blog_post_erb_content = attrs[:body_html]
    record.body = nil
  else
    record.body = attrs[:body_html]
    record.blog_post_erb_content = nil
  end

  record.save!
  puts "  ✓ [#{attrs[:status]}] #{attrs[:title][0..60]}..."
end
puts "  → #{blog_posts_data.length} blog posts seeded (#{blog_posts_data.count { |b| b[:featured] }} featured)"
puts ""

# ===== SERVICE =====
# Single rich-text record — belongs_to :user via has_one :service
puts "── Service ───────────────────────────────────────"

service = user.service || user.build_service
service.description = <<~HTML
  <h3>University Committees</h3>
  <p>Member, UNE Faculty of Humanities, Arts, Social Sciences and Education (HASSE) Academic Board (2023–present). Member, UNE School of Humanities Planning and Assessment Committee (2022–present). Participant, UNE Curriculum Review Working Group for the Bachelor of Urban and Regional Planning (2023–2024).</p>

  <h3>Peer Review</h3>
  <p>Ad-hoc peer reviewer for <em>Urban Policy and Research</em>, <em>Australian Planner</em>, <em>Journal of Transport Geography</em>, and <em>Housing Studies</em>. Reviewer for the State of Australian Cities Conference (SOAC) annual proceedings (2022–present).</p>

  <h3>Professional Bodies</h3>
  <p>Member, Planning Institute of Australia (PIA) — NSW Chapter. Participant, PIA Education Advisory Panel (2023–present), contributing to national curriculum accreditation standards for planning degree programs. Member, Australian and New Zealand Regional Science Association (ANZRSAI).</p>

  <h3>HDR Supervision</h3>
  <p>Principal supervisor, one PhD candidate (Urban Governance, UNE, 2023–present). Co-supervisor, one Masters by Research candidate (Housing Policy, UNE, 2024–present). Panel member, two PhD milestone reviews (2022–2023).</p>

  <h3>Industry Engagement</h3>
  <p>Advisory contributor, NSW Department of Planning, Housing and Infrastructure — Regional Planning Futures Project (2024). Guest speaker, Planning Institute of Australia NSW Chapter seminar series on cross-border governance (2023). Invited panellist, Australian Airport Association Annual Conference (2022).</p>
HTML

service.save!
puts "  ✓ Service record saved"
puts ""

puts "━" * 50
puts "  ✅ Seed complete!"
puts "     #{Teaching.count} teachings | #{ResearchItem.count} research items"
puts "     #{GrantAward.count} grants/awards | #{BlogPost.count} blog posts"
puts "━" * 50
puts ""
