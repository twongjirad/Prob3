
ROOTCFLAGS = `root-config --cflags`
ROOTLIBS   = `root-config --libs`

CXXFLAGS += -O3 -I. -Wall -fPIC
CFLAGS += -O3 -I. -Wall -fPIC


%.o : %.c
	$(RM) $@
	$(CC) -c $(CFLAGS) -o $@ $<

%.o : %.cc
	$(RM) $@
	$(CXX) -c $(CXXFLAGS) -o $@ $*.cc


OBJS    = EarthDensity.o BargerPropagator.o mosc.o mosc3.o 


LIBBASE   = ThreeProb
VER       = 2.10
TAG       = 
LIBALIAS  = $(LIBBASE)$(TAG)
LIBNAME   = $(LIBALIAS)_$(VER)

lib3p     = lib$(LIBNAME).a
lib3pso   = lib$(LIBNAME).so


targets = $(lib3p) $(lib3pso) probRoot probLinear probAnalytic


$(lib3p) : $(OBJS)
	$(RM) $@
	ar clq $@ $(OBJS)
	ranlib $@

$(lib3pso) : $(OBJS)
	$(RM) $@
	$(CXX) -shared -o $@ $^

probRoot: probRoot.o $(lib3p) 
	$(RM) $@
	$(CXX) -o $@ $(CXXFLAGS) -L. $^ $(ROOTLIBS)

.PHONY: probRoot.o
probRoot.o: 
	$(CXX) -o probRoot.o $(ROOTCFLAGS) $(CXXFLAGS) -c probRoot.cc

probLinear: probLinear.o $(lib3p) 
	$(RM) $@
	$(CXX) -o $@ $(CXXFLAGS) -L. $^ $(ROOTLIBS)

.PHONY: probLinear.o
probLinear.o: 
	$(CXX) -o probLinear.o $(ROOTCFLAGS) $(CXXFLAGS) -c probLinear.cc

probAnalytic: probAnalytic.o $(lib3p) 
	$(RM) $@
	$(CXX) -o $@ $(CXXFLAGS) -L. $^ $(ROOTLIBS)

.PHONY: probAnalytic.o
probAnalytic.o: 
	$(CXX) -o probAnalytic.o $(ROOTCFLAGS) $(CXXFLAGS) -c probAnalytic.cc

.PHONY: all
all: $(targets)

.PHONY: clean
clean:
	$(RM) $(targets) *.o

emptyrule:: $(lib3p) $(lib3pso)

