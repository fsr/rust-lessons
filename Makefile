OUTDIR := out
SRCDIR := src
SRCS := $(wildcard src/lesson*.typ)
# ∀%: src/lesson%.typ ⇒ out/lesson%.pdf
OUTS := $(foreach lesson,$(SRCS:.typ=.pdf),$(subst $(SRCDIR)/,$(OUTDIR)/,$(lesson)))
SLIDES = $(SRCDIR)/slides.typ
SYNCDIR := ./
REMOTE := kaki:public_html/rust-lessons
# verbose, checksum, Progress
RSYNCFLAGS := -vcP --exclude-from=rsync_exclude
# tell typst where to look for fonts, equivalent to « --font-path fonts/ »
TYPST_FONT_PATHS := fonts/

# tell make that these are not supposed to be files
.PHONY: all clean watch% lesson% rsync rsync-dryrun

all: $(OUTS) Makefile

clean:
	rm -rf $(OUTDIR)/*.pdf

watch%: $(SRCDIR)/lesson%.typ $(SLIDES) Makefile
	TYPST_FONT_PATHS=$(TYPST_FONT_PATHS) \
	typst watch $< $(subst $(SRCDIR),$(OUTDIR),$(subst .typ,.pdf,$<))

lesson%: $(OUTDIR)/lesson%.pdf
	@true

# tell make that these files have no dependency
$(SRCDIR)/lesson%.typ:
	@true

$(OUTDIR)/lesson%.pdf: $(SRCDIR)/lesson%.typ $(SLIDES) Makefile
	TYPST_FONT_PATHS=$(TYPST_FONT_PATHS) \
	typst compile $< $@

rsync:
	rsync -r $(RSYNCFLAGS) $(SYNCDIR) $(REMOTE)/

rsync-dryrun:
	rsync -rn $(RSYNCFLAGS) $(SYNCDIR) $(REMOTE)/
